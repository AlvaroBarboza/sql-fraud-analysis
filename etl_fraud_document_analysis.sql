-- 1. Extract pending documents and calculate initial SLA
WITH PendingDocs AS (
    SELECT 
        ticket_id,
        user_id,
        document_type,
        status,
        submission_date,
        -- Calculate the exact number of days the document is waiting
        DATEDIFF(day, submission_date, GETDATE()) AS sla_days
    FROM 
        fraud_operation.document_verification
    WHERE 
        status = 'Pending'
),

-- 2. Join with financial risk data
RiskAnalysis AS (
    SELECT 
        p.ticket_id,
        p.user_id,
        p.document_type,
        p.sla_days,
        f.total_transaction_volume,
        f.historical_chargeback_count,
        -- Tag high-risk users based on business rules
        CASE 
            WHEN f.historical_chargeback_count > 0 THEN 'High Risk - CBK History'
            WHEN f.total_transaction_volume > 5000 THEN 'Medium Risk - High Volume'
            ELSE 'Standard'
        END AS risk_flag
    FROM 
        PendingDocs p
    LEFT JOIN 
        fraud_operation.user_financial_history f ON p.user_id = f.user_id
)

-- 3. Final Output: Prioritized Queue for Manual Review
SELECT 
    ticket_id,
    user_id,
    document_type,
    sla_days,
    risk_flag,
    -- Create a priority queue: High Risk first, then order by oldest SLA
    RANK() OVER (
        PARTITION BY risk_flag 
        ORDER BY sla_days DESC, total_transaction_volume DESC
    ) as review_priority_rank
FROM 
    RiskAnalysis
ORDER BY 
    CASE risk_flag 
        WHEN 'High Risk - CBK History' THEN 1
        WHEN 'Medium Risk - High Volume' THEN 2
        ELSE 3
    END,
    review_priority_rank ASC;

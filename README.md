Billing follow up and prediction for Amazon Web services

This application was developed based on the following documentation:
http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/DetailedBillingReports.html


USAGE
=====

Inform: 
- email
- a password
- your aws account number
- aws billing reports bucket
- AMI credentials with access to aws billing reports bucket


The app will daily email you a report with:

- Your Billing amount so far for this month
- Estimate Billing amount for this month, based on a 30 day daily average
- the percent variation from previous month

This information will also be availabe at your home screen

aws-billing
-----------

"#{account_id}-aws-billing-csv-#{year}-#{month}.csv"


InvoiceID,
PayerAccountId,
LinkedAccountId,
RecordType,
RecordID,BillingPeriodStartDate,BillingPeriodEndDate,InvoiceDate,PayerAccountName,LinkedAccountName,TaxationAddress,PayerPONumber,ProductCode,ProductName,SellerOfRecord,UsageType,Operation,RateId,ItemDescription,UsageStartDate,UsageEndDate,UsageQuantity,BlendedRate,CurrencyCode,CostBeforeTax,Credits,TaxAmount,TaxType,TotalCost


v1:
ler a coluna
D e E ate acharmos os totalizadores 
InvoiceTotal	InvoiceTotal:Estimated
AccountTotal	AccountTotal:676854543053
AccountTotal	AccountTotal:306171939414
AccountTotal	AccountTotal:105881016778


Dessas linhas pegamos as colunas
S,X e Y (AC = Total Cost, include Tax)
Descricao, Moeda e Valor
Total amount for invoice Estimated					USD	4125,03
Total for linked account# 676854543053 (TaxWeb)					USD	3636,566458
Total for linked account# 306171939414 (AWS Taxrules)					USD	374,98865
Total for linked account# 105881016778 (Marcos Tagomori)					USD	113,321675





cost-allocation
---------------
InvoiceID,PayerAccountId,LinkedAccountId,RecordType,RecordID,BillingPeriodStartDate,BillingPeriodEndDate,InvoiceDate,PayerAccountName,LinkedAccountName,TaxationAddress,PayerPONumber,ProductCode,ProductName,SellerOfRecord,UsageType,Operation,AvailabilityZone,RateId,ItemDescription,UsageStartDate,UsageEndDate,UsageQuantity,BlendedRate,CurrencyCode,CostBeforeTax,Credits,TaxAmount,TaxType,TotalCost,user:Name,user:custo,user:empresa,user:name

Don't see your tags in the report? New tags are excluded by default - go to https://portal.aws.amazon.com/gp/aws/developer/account?action=cost-allocation-report to update your cost allocation keys.


Detailed line items with resources
----------------------------------
InvoiceID,PayerAccountId,LinkedAccountId,RecordType,RecordId,ProductName,RateId,SubscriptionId,PricingPlanId,UsageType,Operation,AvailabilityZone,ReservedInstance,ItemDescription,UsageStartDate,UsageEndDate,UsageQuantity,BlendedRate,BlendedCost,UnBlendedRate,UnBlendedCost,ResourceId,user:Name,user:custo,user:empresa,user:name



Scheduled process to
--------------------

- Fetch files from s3
- parse csv files and store in database
- update billing indicators         
- prepare and send email reports





rails g scaffold Account name aws_account_id bucket_name access_key secret 
rails g scaffold Report account_id period value 
rails g model ReportLine report_id service value 

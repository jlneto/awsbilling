[ ![Codeship Status for jlneto/awsbilling](https://www.codeship.io/projects/0192d770-ddd0-0131-af05-5236ebb52643/status)](https://www.codeship.io/projects/24718)

Monitor your Amazon Web services Account Spending
=================================================

This application was developed based on the following documentation:
http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/DetailedBillingReports.html
This app reads and parse the csv spending reports on S3 provided by amazon and notifies you about your current expenses.


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

TODO:


Scheduled process to
--------------------

- Fetch files from s3
- parse csv files and store in database
- update billing indicators         
- prepare and send email reports


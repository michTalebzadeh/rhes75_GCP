use accounts;
drop table if exists accounts.ll_18201960_gcp;
CREATE TABLE accounts.ll_18201960_gcp
STORED AS ORC
AS SELECT
	  CAST(transactiondate AS String) AS transactiondate
	, transactiontype
	, sortcode, accountnumber
	, transactiondescription
	, CAST(debitamount AS String) AS debitamount
	, CAST(creditamount AS String) AS creditamount
	, CAST(balance AS String) as balance
FROM ll_18201960;
DESC accounts.ll_18201960_gcp;
SELECT * FROM accounts.ll_18201960_gcp ORDER BY transactiondate;
!exit



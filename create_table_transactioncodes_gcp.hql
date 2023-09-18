use accounts;
drop table if exists accounts.transactioncodes_gcp;
CREATE TABLE accounts.transactioncodes_gcp
STORED AS ORC
AS SELECT
          *
FROM transactioncodes;
DESC accounts.transactioncodes_gcp;
SELECT * FROM accounts.transactioncodes_gcp ORDER BY id;
!exit



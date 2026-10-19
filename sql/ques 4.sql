-- give query to provide the date of nth occuring sunday in future from given data
-- datepart
-- sunday 1
-- monday 2
-- friday 6
-- saturday 7

SET @today_date = '2024-02-04';
SET @n = 3;

SELECT DATE_ADD(
    @today_date,
    INTERVAL (
        (9 - DAYOFWEEK(@today_date)) % 7
        + 7 * (@n - 1)
    ) DAY
) AS next_3_mondays;




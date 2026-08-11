select `date`,`open`,
avg(`open`) over(order by `date` rows between 2 preceding and current row) three_day_moving_avg,
avg(`open`) over(order by `date` rows between 5 preceding and current row) five_day_moving_avg
from share;



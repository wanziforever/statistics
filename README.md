Statistic Analysis Framework

a simple statistic framework, support asynchronous data grabber and data calculation,
a text based database is used for report data.

Also a micro messaging system is implemented in python, very good performance cause
using the shared memory implementation.

will support multiple host computing framework soon

source file directory description:

core/   # the core framework for messaging queue and queue manager implementation
common/ # common utils and base grabber and calculator class, base type definition
apps/   # the actual statistics applications
apps/stat_play_users/     # example to compute the users who did play action
apps/stat_active_users/   # example to compute the active users
apps/stat_play_duration/  # example to compute the average play duration for each user

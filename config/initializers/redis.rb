$controller_stat = Redis.new(:host => "127.0.0.1", :port => 6379)
$controller_stat.select(3)

$action_stat = Redis.new(:host => "127.0.0.1", :port => 6379)
$action_stat.select(4)

$users_stat = Redis.new(:host => "127.0.0.1", :port => 6379)
$users_stat.select(5)

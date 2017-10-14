# setup env
$LOAD_PATH << 'lib'

# load our gem and its jars
require 'mygem'

# load test jar
require_jar 'org.slf4j', 'slf4j-simple', '1.7.7'

# use it
logger = org.slf4j.LoggerFactory.get_logger('root')
logger.info('hello')

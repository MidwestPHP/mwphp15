# Class: composer::params
#
# Configure how the puppet composer module behaves

class composer::params {

  $install_location = '/usr/local/bin/'
  $filename = 'composer'
  $download_location = '/var/www'

}

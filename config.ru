$:.unshift '.'
require 'config/environment'

use AuthorizationsController
use ReservationsController
run ApplicationController

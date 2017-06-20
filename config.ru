$:.unshift '.'
require 'config/environment'

use CalendarsController
use AuthorizationsController
use ReservationsController
run ApplicationController

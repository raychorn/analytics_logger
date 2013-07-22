import "nodes"
import "util"

node default inherits base_production {
	include analytics_bundle::production::tasknode
}
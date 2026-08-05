-- api store data used accross the data and control stages, but not all of that
-- data is useful in the control stage. This reduce memory usage.
local api = require("api")
-- api.warnings = nil -- Are you sure? This disable the warning messages.
api.config = nil
api.storage = nil

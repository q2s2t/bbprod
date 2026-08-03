local api = require("api")

-- api store data used accross the data and control stages, but not all of that
-- data is useful in the control stage. This reduce memory usage.
-- api.warnings = {} -- Are you sure? This disable the warning messages.
api.config = {}
api.storage = {}

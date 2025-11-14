# ohcleandat 1.1.5

# ohcleandat 1.1.4

# ohcleandat 1.1.3
- dropbox_upload returns the path in dropbox where the file was uploaded. 

# ohcleandat 1.1.2
- validation logs vary in the number of columns they have based on type so
we added a flexible col_type variable.

# ohcleandat 1.1.1
- Fix sign issue in validation checks warning on duplication
- Make removes_deletes robust to capitalization errors in the keyword "Delete"

# ohcleandat 1.1.0

# ohcleandat 1.0.0

* changing a key field in the logs from `is_valid` to `no_change`. This will
cause breaking changes.

# ohcleandat 0.3.12

* `expand_frictionless_metadata` can add and remove fields from the metadata depending
on the structural metadata supplied. 

# ohcleandat 0.3.11

* obfuscate gps can now handle NAs

# ohcleandat 0.3.10

* datapackage.json can be pruned to more closely follow structural metadata for
datasets

# ohcleandat 0.3.9

* Files over 300mb are zipped before attempting to upload them to dropbox. Zipped validation logs on dropbox are automatically unzipped. 

# ohcleandat 0.3.8

* Fixing bug in bug fix - naming properties that will be updated

# ohcleandat 0.3.7

* Fixing bug in expand metadata - function now allows for updates

# ohcleandat 0.3.6

* Adds a function to update the descriptive metadata in a frictionless datapackage

# ohcleandat 0.3.5

# ohcleandat 0.3.4

* Setups up a minimal structural metadata framework for tabular datasets. 

# ohcleandat 0.3.3

* Adds more control over the function used in `get_precision` and `obfuscate_gps`

# ohcleandat 0.3.2

* Fixing issue with `download_google_drive` where search pattern is over applied.

# ohcleandat 0.3.1

* Explicitly adding `set_diff` function which was previously a hidden dependency on the {ecohealthalliance/airtabler} package

# ohcleandat 0.3.0

* Adding GPS obfuscation function - this function uses two methods to reduce the
accuracy of GPS points. The first is adding some amount of error to the measurement
from a user defined random uniform distribution. The second is by rounding to
remove precision from the measurement. 

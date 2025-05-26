# payment_with_saldo/__init__.py

# Import other parts of your module
from . import models
from . import controllers
from .hooks import archive_default_shop # Make sure this line exists to import your hooks module

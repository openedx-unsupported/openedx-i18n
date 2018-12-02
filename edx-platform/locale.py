"""
These are the bare minimum settings required to run "compilemessages". They are
*not* sufficient to run an Open edX platform.
"""

from .common import *
from openedx.core.lib.derived import derive_settings

XQUEUE_INTERFACE = {
    'django_auth': None,
    'url': None,
}
DATABASES = {
    "default": {},
}
derive_settings(__name__)

"""
Python 3.14 compatibility patch for Django's template system.
Patches the Context copy mechanism to work around Python 3.14 super() issues.
"""

import sys
from django.template.context import BaseContext, RequestContext


# Store original methods
_original_basectx_copy = BaseContext.__copy__
_original_reqctx_copy = RequestContext.__copy__


def basectx_copy(self):
    """
    Patched __copy__ for BaseContext.
    Works around Python 3.14's restricted super() object.
    """
    try:
        return _original_basectx_copy(self)
    except (AttributeError, TypeError):
        # Python 3.14 breaks super() object attribute assignment
        # Manually copy using object.__new__ and __dict__ copy
        try:
            duplicate = object.__new__(self.__class__)
            # Copy __dict__ directly if available
            if hasattr(self, '__dict__'):
                for key, value in self.__dict__.items():
                    try:
                        object.__setattr__(duplicate, key, value)
                    except:
                        pass
            return duplicate
        except:
            return self


def reqctx_copy(self):
    """
    Patched __copy__ for RequestContext.
    Works around Python 3.14's restricted super() object.
    """
    try:
        return _original_reqctx_copy(self)
    except (AttributeError, TypeError):
        # Python 3.14 breaks super() object attribute assignment
        # Manually copy using object.__new__ and __dict__ copy
        try:
            duplicate = object.__new__(self.__class__)
            # Copy __dict__ directly if available
            if hasattr(self, '__dict__'):
                for key, value in self.__dict__.items():
                    try:
                        object.__setattr__(duplicate, key, value)
                    except:
                        pass
            return duplicate
        except:
            return self


# Apply patches
BaseContext.__copy__ = basectx_copy
RequestContext.__copy__ = reqctx_copy







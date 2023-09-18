import time

import functions_framework


# Placeholder
def heavy_computation():
    return time.time()


# Placeholder
def light_computation():
    return time.time()


# Global (instance-wide) scope
# This computation runs at instance cold-start
instance_var = heavy_computation()


@functions_framework.http
def scope_demo(request):
    """
    HTTP Cloud Function that declares a variable.
    Args:
        request (flask.Request): The request object.
        <http://flask.pocoo.org/docs/1.0/api/#flask.Request>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>.
    """

    # Per-function scope
    # This computation runs every time this function is called
    function_var = light_computation()
    return f"Instance: {instance_var}; function: {function_var}"



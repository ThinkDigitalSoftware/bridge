import asyncio

# async def register(service_name: str, functions: list):
#     body = {"register_as": "service", "name": service_name, "functions": functions}
#     async with websockets.connect(service_uri) as websocket:
#         print(f'registering {service_name} with the bridge')
#
#         await websocket.send(str(body))
#         response = await websocket.recv()
#         print(response)
from api_function import ApiFunction


async def main():
    # await register('echo_service', functions=['echo'])
    current_time_function = ApiFunction(service='time', function='get_time',
                                        data={'data': 'now'})
    print("Grabbing the current time from Bridge's time function")
    print(f"The current time is {current_time_function.call()['data']}")
    print("Let's have Bridge echo this back for us.")
    echo_function = ApiFunction('echo', 'echo', {'data': {}})
    print(echo_function.call())
    print("Let's have Bridge call a service that isn't registered.")
    foo_func = ApiFunction('foo', 'bar', {'data': {'data': 'baz'}})
    print(foo_func.call())

    print("Now let's get some server information")
    system = ApiFunction(service='system', function='list_services')
    print(system.call())


if __name__ == '__main__':
    asyncio.run(main())

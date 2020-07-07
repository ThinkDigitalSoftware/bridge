import json

import requests


class ApiFunction:
    def __init__(self, service: str, function: str, data: dict = None):
        self.service = service
        self.function = function
        self.data = data

    def call(self):
        response = requests.post(url='http://localhost:8080',
                                 json={'service': self.service, 'function': self.function, 'data': self.data})
        response_json = json.loads(response.text)
        return response_json

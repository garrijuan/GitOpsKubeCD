import unittest
from fastapi.testclient import TestClient
from apppython.app.main import app

class TestApp(unittest.TestCase):
    def setUp(self):
        self.client = TestClient(app)

    def test_read_root(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"Hola": "Virulo 2"}) 

if __name__ == "__main__":
    unittest.main()

import unittest
from apple_power import parse_power_line
class TestPower(unittest.TestCase):
 def test_milliwatts(self):self.assertEqual(parse_power_line('CPU Power: 1234 mW'),('cpu_power_watts',1.234))
 def test_watts(self):self.assertEqual(parse_power_line('GPU Power: 2.5 W'),('gpu_power_watts',2.5))
 def test_unrelated(self):self.assertIsNone(parse_power_line('CPU frequency: 2000 MHz'))
if __name__=='__main__':unittest.main()

import unittest
from energy_analysis import estimate,repeat_statistics
class TestEnergy(unittest.TestCase):
 def test_baseline_subtraction(self):
  s=[(i*1_000_000_000,10 if i<5 else 20) for i in range(11)]
  r=estimate(s,(0,4_000_000_000),(6_000_000_000,10_000_000_000),"test")
  self.assertEqual(r["status"],"estimated_incremental")
  self.assertAlmostEqual(r["net_joules"],40)
 def test_gaps(self):
  s=[(0,10),(10_000_000_000,20)]
  self.assertTrue(estimate(s,(0,1_000_000_000),(9_000_000_000,10_000_000_000),"test")["status"].startswith("unavailable"))
 def test_repeat_uncertainty(self):
  self.assertEqual(repeat_statistics([{"status":"estimated_incremental","net_joules":i} for i in (1.,2.,3.)])["n"],3)
if __name__=="__main__":unittest.main()

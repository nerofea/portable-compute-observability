import importlib.util,pathlib,tempfile,unittest
spec=importlib.util.spec_from_file_location("native_telemetry",pathlib.Path(__file__).with_name("native_telemetry.py"))
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class Tests(unittest.TestCase):
 def test_integrate(self):
  s=[(1_000_000_000,10,"x"),(2_000_000_000,20,"x"),(3_000_000_000,10,"x")]
  self.assertAlmostEqual(m.integrate_power(s,1_000_000_000,3_000_000_000),30)
  self.assertAlmostEqual(m.integrate_power(s,1_500_000_000,2_500_000_000),17.5)
 def test_bounds(self):
  s=[(1,10,"x"),(2,10,"x")]
  self.assertIsNone(m.integrate_power(s,0,2))
  self.assertIsNone(m.integrate_power(s,1,3))
 def test_gaps(self):
  self.assertIsNone(m.integrate_power([(1,1,"x"),(9_000_000_001,1,"x")],1,9_000_000_001))
 def test_csv(self):
  with tempfile.TemporaryDirectory() as d:
   p=pathlib.Path(d)/"p.csv";p.write_text("unix_ns,power_watts,source\n1,5,meter\n2,6,meter\n")
   self.assertEqual(len(m.read_power_csv(p)),2)
   p.write_text("unix_ns,power_watts,source\n2,5,meter\n1,6,meter\n")
   with self.assertRaises(ValueError):m.read_power_csv(p)
if __name__=="__main__":unittest.main()

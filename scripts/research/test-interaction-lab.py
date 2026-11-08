#!/usr/bin/env python3
import importlib.util, pathlib, tempfile, unittest
p=pathlib.Path(__file__).with_name("interaction-lab.py")
spec=importlib.util.spec_from_file_location("lab",p)
lab=importlib.util.module_from_spec(spec);spec.loader.exec_module(lab)
class LabTests(unittest.TestCase):
    def test_percentile(self):
        self.assertEqual(lab.percentile([1,3,5],.5),3)
        self.assertEqual(lab.percentile([1,3,5],0),1)
    def test_bootstrap(self):
        self.assertEqual(lab.bootstrap_median_ci([7]*5),[7,7])
    def test_energy(self):
        s=[(0,10,"meter"),(1000000000,20,"meter"),(2000000000,30,"meter")]
        self.assertAlmostEqual(lab.energy_in_window(s,500000000,1500000000),20)
        self.assertIsNone(lab.energy_in_window(s,-1,1000000000))
    def test_power_contract(self):
        with tempfile.TemporaryDirectory() as d:
            f=pathlib.Path(d)/"power.csv"
            f.write_text("unix_ns,power_watts,source\n1,12.5,external\n2,13.5,external\n")
            self.assertEqual(len(lab.load_power_csv(f)),2)
if __name__=="__main__":unittest.main()

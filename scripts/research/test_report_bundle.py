import csv,pathlib,tempfile,unittest
from report_bundle import bundle,summarize_csv
class ReportTests(unittest.TestCase):
 def test_groups_and_scopes(self):
  with tempfile.TemporaryDirectory() as d:
   p=pathlib.Path(d)/"data.csv"
   p.write_text("backend,workload,elements,iteration,dispatch_completion_ns,gpu_command_ns,validation\nmetal,vector_add,32,0,100,40,pass\nmetal,vector_add,32,1,200,60,pass\n")
   r=summarize_csv(p,"metal")
   self.assertEqual(len(r),1)
   self.assertEqual(r[0]["timing_scope"],"dispatch_completion_ns")
   self.assertEqual(r[0]["median_ns"],150)
 def test_artifacts(self):
  with tempfile.TemporaryDirectory() as d:
   root=pathlib.Path(d);(root/"results/raw").mkdir(parents=True)
   (root/"results/raw/a.csv").write_text("workload,elements,latency_ns\nvector_add,16,100\n")
   session=root/"results/sessions/test";session.mkdir(parents=True)
   counts,metrics=bundle(session,root,[{"name":"cpu","status":"ok","raw_csv":["results/raw/a.csv"]}])
   self.assertEqual(counts["ok"],1)
   self.assertEqual(len(metrics),1)
   for name in ("summary.csv","kernel_metrics.csv","report.md","report.txt","report.html","report.json","raw/a.csv"):
    self.assertTrue((session/name).exists(),name)
if __name__=="__main__":unittest.main()

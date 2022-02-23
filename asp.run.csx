using System;
using System.Net;

var ipv4 = Dns.GetHostEntry(Dns.GetHostName()).AddressList[1];

Process p = new Process();
    p.StartInfo.FileName = "C:\\Program Files\\dotnet\\dotnet.exe";
    p.StartInfo.Arguments = $"watch run --launch-profile ipad --urls https://{ipv4}:443";
    p.Start();
    p.WaitForExit();
    p.Kill();

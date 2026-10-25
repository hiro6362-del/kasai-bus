import os,json,re,sys
d=sys.argv[1]; out={}
for f in sorted(os.listdir(d)):
    stop,route,pole=f[:-4].split('_'); cur=None; days={}
    for line in open(os.path.join(d,f),encoding='utf-8'):
        line=line.strip()
        if not line: continue
        if line.startswith('#'): cur={'11':'wd','12':'sa','13':'ho'}[line[1:]]; days[cur]=[]; continue
        h,ms=line.split(':',1)
        for m in ms.split():
            mk=re.match(r'^(\D*)(\d\d)$',m); assert mk,(f,line,m)
            days[cur].append([int(h)*60+int(mk.group(2)),mk.group(1)])
    for k in days: days[k].sort()
    out[f"{stop}_{route}"]={'pole':int(pole),'t':days}
print(json.dumps(out,ensure_ascii=False,separators=(',',':')))

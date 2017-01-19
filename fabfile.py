from fabric.api import *


#____________________[ ENVIRONMENT CONFIGS ]
#env.user = "root"
env.key_filename = "/home/julio/.ssh/id_rsa.pub"
env.skip_bad_hosts = True
env.output_prefix = False	

#____________________[ ROLES ]
env.roledefs = {
"linux"   : open("linux.txt").read().split("\n"),
"windows" : open("windows.txt").read().split("\n"),
"aix"     : open("aix.txt").read().split("\n")
}



#______________________________________[ GET_CLM ]
def clm():
    import rat 
    from pprint import pprint as pp
    from timeit import default_timer as timer

    start = timer()
    try:
        #pp(rat.get_apps(env.host,APP))
        a = rat.CLM(env.host)
        
        """
        get server & apps separately so that can be possible 
        arm the csv with  more ease
            
        """

        #py3 version
        srv = list(a.keys())[0]
        apps =list(a[srv].keys())
         
        result = []

        for app in apps:
            try:
                result.append(",".join([ i[1] for i in sorted(a[srv][app].items())  ]) )

            except Exception as ex:
                print(ex)
	
        #print(result)
	
        for i in result:
            print(i)

    except:
        pass



#______________________________[ get devops apps ]
def dvps():
    from dvps import DEVOPS
    from pprint import pprint as pp
    from timeit import default_timer as timer

    try:
        a = DEVOPS(env.host)

        srv = list(a.keys())[0]
        apps =a[srv]
       
        result = []
        for key in sorted(apps):
            try:
                #print(key)
                result.append(apps[key])
            except Exception as ex:
                print(ex)
        
        result = str(srv) + "," + ",".join([i for i in result])

        print(result)
        return result

    except:
        pass


def get_jts():

    from rat import api_get_version as version
    from rat import CLM 
    from pprint import pprint as pp

    try:
        try:
            data = CLM(env.host)
            a=1

        except:
            pass

        if a == 1:

            #py3 version
            SRV  = list(data.keys())[0]
            APPS = list(data[SRV].keys())
            JTS  = list([data[SRV][i]["JTS"] for i in data[SRV].keys()])

            for jts in JTS:
                jtsv = []
                JTSv = version(jts)
                for k,v in JTSv.items():
                    jtsv.append("{k},{v}".format(k=k,v=v))

                print("{server},{version}".format(server=env.host,version=jtsv[0]))

    except:
        pass



def test():
    try:
       #___________________________________________[ hide printing ]
        with hide('running', 'stdout', 'stderr'):
            put("/home/julio/Projects/fabric/jts_fab.sh","/tmp/jts_fab.sh", mode=775)

        run("/tmp/jts_fab.sh")
    except:
        pass



def ping(TYPE):
    """
    Where TYPE is OS_TYPE / linux,windows,aix, taken from roledefs
    """


    from multiprocessing import Queue,Process,Manager
    import subprocess,os,re
    

    #all_rat = open("/home/julio/Projects/fabric/linux.txt").read().split("\n")

    if re.search("windows|aix|linux" , TYPE):
        all_rat = [i for i in env["roledefs"][TYPE] if i]
    else:
        all_rat = open(TYPE).read().split("\n")



    def pinger( job_q, results_q ):

        DEVNULL = open(os.devnull,'w')

        while True:
            ip = job_q.get()
            if ip is None: break

            try:
                subprocess.check_call(['ping','-c1',ip], stdout=DEVNULL)
                results_q.put(ip)

            except:
                print(ip + " , dead")
                pass

    pool_size = len(all_rat)

    jobs = Queue()
    results = Queue()
    D = Manager().dict()
    D["live"] = []
    D["dead"] = []

    
    pool = [ Process(target=pinger, args=(jobs,results))  for i in range(pool_size) ]

    for p in pool:
        p.start()

    for i in all_rat:
        jobs.put(i)

    for p in pool:
        jobs.put(None)

    for p in pool:
        p.join()

    while not results.empty():
        ip = results.get()
        print(ip + " , live")

    print(D)



def version():

	with hide('warnings','running', 'stderr'):
		try:
			run("uname -a")
		except:
			print(env.host)
			pass
	



def win_check_db2(APP):
	
	cmd = """ powershell -Command \"Get-Process \" </dev/null |grep -i  """ + APP + """ >/dev/null && echo Yes || echo No """
	env.warn_only = True
	#env.user = "dstadmin"
	#env.abort_on_prompts = True

	with hide('warnings','running', 'stdout', 'stderr'):

		result = run(cmd)

	if result:
		print(env.host, result, sep=",")



def check_ssh():
    from multiprocessing import Queue,Process,Manager
    import subprocess,os

    def chk_port(job_q, resul):
        pass
   


def Cpool():
    import rat
    from pprint import pprint as pp
    #print(env.host)
    pp(rat.CLM(str(env.host)))



def version():
    with hide('running', 'stdout', 'stderr'):
        with warn_only():
            try:
                version = run("uname")
                if version:
                    version = "success"
                else:
                    version = "not working"
            except Excetions as ex:
                print(ex)

    print(env.host,version, sep=",")

    




def turn_on(TYPE):
    pass

def turn_off(TYPE):
    pass




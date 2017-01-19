import sys,os,re,paramiko,itertools,pprint,socket,collections

global res,tssh,teamserver
pp = pprint.PrettyPrinter(indent=4)


def chk_conn(server):

    global tssh,res

    #_______________________[ setting up ssh_client ]
    tssh = paramiko.SSHClient()
    key="/home/julio/.ssh/id_rsa.pub"
    tssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())


    #break unless all settings TRUE
    tssh.connect(server, username="root", key_filename=key, timeout=11)

    if tssh.get_transport().is_active()        == True and \
       tssh.get_transport().is_alive()         == True and \
       tssh.get_transport().is_authenticated() == True:
        return "ok"

    else:
        return "no_connection"



def get_apps(SERVER,APP):

    global tssh,res,teamserver,fqdn,number

    if chk_conn(SERVER) == "ok":
        #print("canary conn")
        #print("server %s" % SERVER)

        #get process list
        inp, out, err = tssh.exec_command("ps -w -w -e pid,user,cmd,args |grep -i java")
        processes = out.readlines()
        processes = list(filter(lambda x: x != "\n", processes))
        PROCESSES = [i.strip() for i in processes]

        #set depth
        fqdn = socket.getfqdn(SERVER)
        res={}
        #________________[ result & defines the hostname within ]
        res[fqdn] = {}

        #____________[ lookup for CLM ]
        if APP == "CLM":
            CLM(PROCESSES)

        #____________[ lookup for DEVOPS ]
        if APP == "DEVOPS":
            DEVOPS(PROCESSES)


    return res



#___________________________________________________________[ APPS / help FX ]



#_____________________________________________________________________________[ C L M  STUFF ]
def CLM():

    global server,tssh
    number = 1


    for proc_num in PROCESSES:

        if "JAZZ_HOME" in proc_num:
            #______________________________________________________[ get profile variable - was or apache ]
            if "catalina" in proc_num:
                profile = re.search("-Dcatalina.home=((/\w+(/)*)*(server(/)*([0-9a-zA-Z_.-]*)))",proc_num, re.I).groups()[0]
            else:
                profile = re.search("-Duser.install.root=((/[0-9a-zA-Z_.\-]+(/)*)*(profiles(/)*([0-9a-zA-Z_.-]*)))",proc_num, re.I).groups()[0]

            #get home & clean it
            jazz_home   = re.search("-DJAZZ_HOME=file:(/+([0-9a-zA-Z_.\-]+/*)+)\s*",proc_num,re.I).groups()[0]
            #fixed "/"
            jazz_home   = re.sub("//+", "/", jazz_home)

            #______________________________________________________[ declaring table ]
            res[fqdn]["App" + str(number)]              = {}
            res[fqdn]["App" + str(number)]["App"]       = "Null"
            res[fqdn]["App" + str(number)]["Server"]    = fqdn
            res[fqdn]["App" + str(number)]["User"]      = re.split("\s*", proc_num)[0]
            res[fqdn]["App" + str(number)]["Profile"]   = profile
            res[fqdn]["App" + str(number)]["Jazz_Home"] = jazz_home.replace("/server/conf", "")
            res[fqdn]["App" + str(number)]["Webapps"]   = "Null"
            res[fqdn]["App" + str(number)]["JTS"]       = "Null"
            res[fqdn]["App" + str(number)]["Version"]   = "Null,Null"
            res[fqdn]["App" + str(number)]["DB"]        = {}

            #______________________________________________________[ TEAMSERVER.PROPERTIES ]
            inp, out, err = tssh.exec_command("find " + jazz_home + " -iname teamserver.properties -exec cat {} \;")
            teamserver = out.readlines()
            dbs = []
            urls = []

            for app in teamserver:
                #_________________________________________[ getting webapps ]
                try:
                    if re.search("webapp", app):
                        #print("canary webapps")
                        urls.append(re.search("^.*(https.*)\n$", app).groups()[0].replace("\\", ""))
                        res[fqdn]["App" + str(number)]["Webapps"] = "|".join([i for i in urls])



                except Exception as ex:
                    print("error on webapps: %s" % ex)



                #__________________________________________[ getting jts ]
                try:
                    if re.search("jts.url", app):
                        #print("canary webapps")
                        url = (re.search("^.*(https.*)\n$", app).groups()[0].replace("\\", ""))
                        res[fqdn]["App" + str(number)]["JTS"] = url

                except Exception as ex:
                    print("error on jts: %s" % ex)



                #_________________________________________[ getting dbs ]
                try:
                    if "jdbc.location=//" in app:
                        #print(app)
                        try:
                            #if "derby" in app:

                            db = re.search("^com.*jdbc.location=//(.*);password.*$", app).groups()
                            db = re.split(":|/|user=",re.match(".*location=//(.*);pass.*$", app).groups()[0].replace("\\", ""))
                            db = [i for i in db if i != ""]
                            dbs.append(db)
                            dbs.sort()
                            t = ""
                            dbs2 = []

                            #__________________[ getting uniq's ]
                            for elem in dbs:
                                if elem != t:
                                    dbs2.append(elem)
                                t = elem

                            #__________________[ dbs list ]
                            #print(dbs2)
                
                            nu = 1
                            for d in dbs2:
                                try:
                                    server,port,db,instance = d
                                    res[fqdn]["App" + str(number)]["DB"]["db"+str(nu)] = {
                                          "server"  : server,
                                          "port"    : port,
                                          "dbName"  : db,
                                          "instance": instance
                                          }

                                except:
                                    pass
                                nu += 1

                        except:
                            pass

                except Exception as ex:
                    print("%s: error on dbs: %s\n" % ("App" + str(number),ex))



                #[ ---------------------------------------------------------- Teamserver.properties seek ENDS ]

           #____________________________________[ CLM getting Version ]
            try:
                wap = res[fqdn]["App" +str(number)]["JTS"]
                res[fqdn]["App" + str(number)]["Version"] = api_get_version(wap)[0]

            except:
            #    print("error on friends : %s" % ex)
                pass



            #_____________________________________[ was_console / version ]
            if not "tomcat" in profile:
                try:
                    inp1, out1, err1 = tssh.exec_command('find '+ profile +' -name portdef.props -exec cat {} \;')
                    console = out1.readlines()
                    port = [i for i in console if "WC_adminhost_secure" in i][0].split("=")[1].strip()
                    console = "https://{server:s}:{port:s}/ibm/console".format(server=fqdn, port=str(port)) 
                    res[fqdn]["App" + str(number)]["Was_console"] = console

                except Exception as ex:
                    pass

                try:
                    inp1, out1, err1 = tssh.exec_command(profile + "/bin/versionInfo.sh  |grep -iE 'Version.*[0-9.]+' |grep -iv directory|awk 'NR>1 {print $2}'" )
                    version = out1.readlines()[0].strip()
                    res[fqdn]["App" + str(number)]["Was_version"] = version

                except Exception as ex:
                    pass


            #flatten the db stuff
            db_tmp = []
            for db in res[fqdn]["App" + str(number)]["DB"].values():
                db_tmp.append(":".join([i for i in db.values()]))

            res[fqdn]["App" + str(number)]["DB"]  = "|".join([i for i in db_tmp])



            #__________________________________________[ naming app ]
            #if all in one
            try:
                if "|" in res[fqdn]["App" + str(number)]["Webapps"]:
                    appp = "AiO" #ALL-IN-ONE
                    res[fqdn][appp + str(number)]          = res[fqdn].pop("App" + str(number))
                    res[fqdn][appp + str(number)]["App"]   = appp
                #if not all in one place the name of the app
                else:
                    appp = res[fqdn]["App" + str(number)]["Webapps"].split("/")[-1].upper()
                    res[fqdn][appp]  = res[fqdn].pop("App" + str(number))
                    res[fqdn][appp]["App"]  = appp
                #if not all in one place the name of the app
            except:
                pass

        number += 1

    #_______________________[ check if distributed version ]
    pus = []
    cmd2 = """find /opt /appsdata -type f  -iname "httpd.conf" 2>/dev/null | xargs ls -1tr |tail -1 | xargs grep plugin-cfg.xml |awk '{print $NF}' |xargs cat"""
   
    try:
        stdin, stdout, stderr = tssh.exec_command(str(cmd2))
        file=stdout.readlines()
        if len(file) != 0 :
            for i in file:
                try:
                    pus.append(str(re.search('Transport Hostname="(.*)"',i).groups(0)[0]))
                except:
                    pass
            pus = set(pus)
            for i in pus:
                if not "Protocol" in i:
                    pus = "{server:s}".format(server=",".join([i for i in pus]))
                    res[fqdn]["Distributed"] = pus
    except:
        pass
        #full_list={}
        #for server_dist in res[fqdn]["Distributed"].split(","):
        #    full_list.update(get_apps(server_dist))

    
    return res




#_____________________________________________________________________________[ DEVOPS STUFF ]
def DEVOPS(SERVER):

    def chk_conn(server):
        #_______________________[ setting up ssh_client ]
        tssh = paramiko.SSHClient()
        key="/home/julio/.ssh/id_rsa.pub"
        tssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())


        #break unless all settings TRUE
        tssh.connect(server, username="root", key_filename=key, timeout=11)

        if tssh.get_transport().is_active()        == True and \
           tssh.get_transport().is_alive()         == True and \
           tssh.get_transport().is_authenticated() == True:
            return "ok"

        else:
            return "no_connection"



    if chk_conn(SERVER) == "ok":

        #get process list
        inp, out, err = tssh.exec_command("ps -w -w -e pid,user,cmd,args |grep -i java")
        processes = out.readlines()
        processes = list(filter(lambda x: x != "\n", processes))
        PROCESSES = [i.strip() for i in processes]

        #set depth
        fqdn = socket.getfqdn(SERVER)
        res={}
 
        number = 1
        
        APPS = {
                "UCD_Server"  : "com.urbancode.ds.UDeployServer",
                "UCD_Agent"   : "com.urbancode.air.agent.AgentWorker",
                "UCR"         : "org.apache.catalina.startup.Bootstrap",
                "UCDwP_Server": "DDDDDDDDDDDD",
                "Jira"        : "-Datlassian.standalone=JIRA",
                "Jenkins"     : "DJENKINS_HOME",
                "Git"         : "config/unicorn.rb"
                }

        res[fqdn] = {}
        res[fqdn]["UCD_Server"]   = "Null"
        res[fqdn]["UCD_Agent"]    = "Null"
        res[fqdn]["UCR"]          = "Null"
        res[fqdn]["UCDwP_Server"] = "Null"
        res[fqdn]["Jira"]         = "Null"
        res[fqdn]["Jenkins"]      = "Null"
        res[fqdn]["Git"]          = "Null"

        #res[fqdn]["test"] = "Null"

        for proc_num in PROCESSES:

            try:
                for app,value in APPS.items():
                    if value in proc_num:
                        res[fqdn][app] = "Active"

            except:
                pass

        return res



#___________________________[ api connection ]
def api_connect(URL):

   global s

   import requests

   #____[ setting up url ]
   URL1=str(URL)+"/authenticated/identity"
   URL2=str(URL)+"/authenticated/j_security_check"

   #____[ setting up config ]
   requests.packages.urllib3.disable_warnings()
   s = requests.Session()
   h = {'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8','Accept-Encoding': 'gzip, deflate'}
   p = {'j_password': 'acces4dst', 'j_username': 'dstacces@us.ibm.com'}

   #____[ actual connection ]
   #get_cookies
   a = s.get(URL1, verify=False, headers=h)
   #connect to api
   b = s.post(URL2, data=p, verify=False, cookies=a.cookies)
   #print(b.text)

   return s,b.text


#_______________________________[ get_application_friends ]
def api_get_friends(URL):
    
    from bs4 import BeautifulSoup as bs

    global s,links
    api_connect(URL)

    #___[ set to get friends ]
    friends = s.get(URL +"/friends", cookies=s.cookies,verify=False)
    soup = bs(friends.text, "html.parser")
    links = [i.get("rdf:resource") for i in soup.findAll("jd:rootservices")]

    links = [i.replace("/rootservices","") for i in links]
    links.sort()

    return links

#def clm_api_db_status(URL):

#________________________________[ get app version ]
def api_get_version(URL):

    from bs4 import BeautifulSoup as bs

    global s,links

    api_connect(URL)

    #___[ set the url to get version ]
    Version_info = s.get(URL +"/service/com.ibm.team.repository.service.internal.IProductRegistryRestService/allProductInfo", cookies=s.cookies,verify=False)
    soup = bs(Version_info.text, "html.parser")
    version = []
    
    #___[ main fetching , xml parsing]
    for i in soup.findAll("values"):
       
        try:
            ifix=i.findAll("buildid")[1].getText()
        except:
            ifix="NoIfix"
            pass

        version.append("{ver:s},{ifix:s}".format(ver=str(i.find("version").getText()),ifix=str(ifix)))
        version =  list(set(version))

    return version



#____________________________[ micro-framework to turn on/off apps ]
def clm_profile_ops(URL):
   
    global tssh

    import re

    #____________[ if a url is given clean it to get hostname ]
    if re.search("http.*", URL):
        server = re.search("http.://(.*):.*", URL).groups()[0]
    else:
        server = URL

    apps = get_apps(server)['App']

    res={}
    for url in apps:
        res.update({apps[url]["Webapps"] : apps[url]["Profile"]})


    def menu():
        choise = ""
        while choise != "q":
            for url in res:
                print("""Operations :
                
                [1] stop  profile
                [2] start profile
                [3] clean cache
                [4] get   users on pa
                [5] get   admins on pa
                
                """)
                choise = input("selection : ")
    
    return res


#_________________________[ CBF tool ]
def get_cbf(URL):

    import re

    #____________[ if a url is given clean it to get hostname ]
    if re.search("http.*", URL):
        server = re.search("http.://(.*):.*", URL).groups()[0]
    else:
        server = URL

    apps = get_apps(server)

    res={}
    profiles,servers,dbs,urls = [],[],[],[]

    profiles = [ apps[fqdn][url]["Profile"] for url in apps[fqdn] ]
    profiles = "\n".join([i for i in profiles])


    
    #__________________________[ get elements per instance,server,dbName ]
    #instance,server,db
    i,s,d = [],[],[]
    for url in apps[fqdn]:
        for db in apps[fqdn][url]["DB"]:
            ins=apps[fqdn][url]["DB"][db]["instance"]
            srv=apps[fqdn][url]["DB"][db]["server"]
            dbn=apps[fqdn][url]["DB"][db]["dbName"]
            i.append(ins)
            s.append(srv)
            d.append(dbn)

    #__________________________[ get db uniques elements ]
    dbs2=list(map(set,[i,s,d]))
    dbs2=[list(d) for d in dbs2]
    dbs3=[]
    #__________________________[ put together the info ]
    for j in dbs2: 
        dbs3.append("{sa:s}".format(sa=":".join([i for i in j])))

    dbs = "{hostname:s}:{instancia:s}:{dbs:s}".format(instancia=dbs3[0],hostname=dbs3[1],dbs=dbs3[2])

    
    servers = apps["server"]
    servers = servers + "\n" + (dbs3[1])

    #__________________________[ get urls ]
    urls=[]
    for appn in apps[fqdn]:
        try:
            urls.append(apps[fqdn][appn]["Webapps"])
            urls.append(apps[fqdn][appn]["Friends"])
            

        except:
            pass

    urls =list(set(urls))
    if "," in " ".join([i for i in urls]):
        urls2=[]
        for url in urls:
            urls2.append("\n".join([i for i in url.split(",")]))
            #urls2 = ("\n".join([i for i in urls2]))

    urls2 = ("\n".join([i for i in urls]))
    cbf_entry = ""

#    for url in apps[fqdn]:
    res = { "dbs"      : dbs,
            "server"   : servers,
            "urls"     : urls2,
            "profiles" : profiles,
            "CBF_entry": cbf_entry
          }

    for k,v in res.items():
        print("-"*12 + k  + "-"*12+"\n" + "".join(i for i in v))
    print("-"*12)

    return res





#____________________________[ get project areas ]
def api_get_pas(URL):

    from bs4 import BeautifulSoup as bs

    global s

    api_connect(URL)
    if URL.endswith("/"): URL = URL[:-1]

    pas_xml = s.get(URL + "/process/project-areas", cookies=s.cookies)
    
    soup = bs(pas_xml.text, "xml")
    pas = soup.findAll("project-area")
    pas_={}
    for pa in  pas:
        pa_name     = pa.find("summary").getText(),
        pa_url      = pa.find("url").getText(),
        pa_members  = pa.find("members-url").getText(),
        pa_admins   = pa.find("admins-url").getText(),
        pa_prj_admin= pa.find("project-admins-url").getText()

        pas_ = {
                "Name"     : pa_name,
                "Url"      : pa_url,
                "Members"  : pa_members,
                "Admins"   : pa_admins,
                "PrjAdmin" : pa_prj_admin
                }
    return pas_



def unique(l):
    tmp = []
    t = ''
    for elem in l:
        if elem != t:
            tmp.append(elem)
        t=elem
    return tmp




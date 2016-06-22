global with sharing class TimerController {

    public List<Project__c> projects {get;set;}
    public List<Project__c> projectsLastWeek {get;set;}
    public Project__c masterProject {get;set;}
    public Project__c project {get;set;}
    public String pros {get;set;}
    public Boolean hasLastWeek {get;set;}

    public TimerController(){
        
        projectsLastWeek = [ 
            SELECT Id, Name, Name__c, Time__c, Day_of_Week__c, Time_in_Seconds__c
            FROM Project__c
            WHERE CreatedDate = Last_WEEK
            ORDER BY CreatedDate DESC
        ];
        if(projectsLastWeek.size() > 0){
            hasLastWeek = true;
        } else {
            hasLastWeek = false;
        }
        
        projects = getProjects();
        project = new Project__c();
        try{
            masterProject = getMasterProject();
            pros = masterProject.projects__c;
        } catch(Exception e){
            system.debug('First run - no master yet' + e);
        }
        String bin = '';
    }
    
    @RemoteAction
    global static String pushTime(Decimal timed, String name) {
        String result;
        
        Project__c projectToInsert = new Project__c();
        
        projectToInsert.Name__c = name;
        projectToInsert.Time_in_Seconds__c = timed;
        
        system.debug(timed);
        //try{
            insert projectToInsert;
            //pushTime = 'pushedTime ' + timed;
        /*}catch(Exception e){
            pushTime = 'Houston we have a problem... ' + e;
        }*/
        
        Project__c projectInserted = [select id, name, Name__c, Day_of_Week__c, Time__c From Project__c where id = :projectToInsert.id];
        result = 'Saved ' + projectInserted.Time__c + ' to your ' + projectInserted.Name__c + ' project.';
        return result;
    }
    
    @RemoteAction
    global static String pushName(String name) {
    
        String result;
        List<Project__c> projects = new List<Project__c>();
        Project__c projectToUpdate = new Project__c();
        
        projects = [ 
            SELECT Id, Name, Name__c, Time__c, Time_in_Seconds__c, Projects__c, Day_of_Week__c
            FROM Project__c
            WHERE Name = 'Master'
        ];
        
        String bin = '';
        String newProjList = '';
        Id projId;
        if(projects.size() > 0){
            for(Project__c pro : projects){
                if(pro.Projects__c != null){
                    
                    if(pro.Projects__c.length() >= bin.length()){
                        newProjList = bin + ', ' + name;
                        projId = pro.id;
                        system.debug('test1 + ' + newProjList);
                    }
                    
                    bin = pro.projects__c;
                    
                }
            }
            
            projects = new List<Project__c>();
            projectToUpdate = [select id, name, projects__c from Project__c where name = 'Master'];
            bin = projectToUpdate.Projects__c;
            projectToUpdate.name = 'Master';
            projectToUpdate.Projects__c = bin + ', ' + name;
            
            projects.add(projectToUpdate);
            
            update projects;
            
        } else {
            
            projects = new List<Project__c>();
            projectToUpdate = new project__c();
            projectToUpdate.name = 'Master';
            projectToUpdate.projects__c = '(Nothing Selected), ' + name;
            projects.add(projectToUpdate);
            insert projects;
        }
        
        result = name;
        return result;
    }
    
    @RemoteAction
    global static String delName(String projs) {
        
        String result;
        Project__c project = [
            SELECT Id, Name, Name__c, Time__c, Time_in_Seconds__c, Projects__c, Day_of_Week__c
            FROM Project__c
            WHERE name = 'master'
            LIMIT 1
        ];
        
        project.Projects__c = projs;
        
        update project;
        
        result = projs;
        return result;
    }
    
    public Project__c getMasterProject(){
        masterProject = [ 
            SELECT Id, Name, Name__c, Time__c, Time_in_Seconds__c, Projects__c, Day_of_Week__c
            FROM Project__c
            Where name = 'Master'
            LIMIT 1
        ];
         
        return masterProject;
    }
    
    public List<Project__c> getProjects(){
        projects = [ 
            SELECT Id, Name, Name__c, Time__c, Time_in_Seconds__c, Projects__c, Day_of_Week__c
            FROM Project__c
            WHERE CreatedDate = THIS_WEEK
            ORDER BY CreatedDate DESC
        ];
         
        return projects;
    }
    
    public List<Project__c> getProjectsLastWeek(){
        projectsLastWeek = [ 
            SELECT Id, Name, Name__c, Time__c, Time_in_Seconds__c, Projects__c, Day_of_Week__c
            FROM Project__c
            WHERE CreatedDate = Last_WEEK
            ORDER BY CreatedDate DESC
        ];
        
        return projectsLastWeek;
    }
}
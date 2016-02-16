public class myclass {

    public contact con {get;set;}
    public myclass(){
        con = [select id from contact limit 1];
        
    }
    
}
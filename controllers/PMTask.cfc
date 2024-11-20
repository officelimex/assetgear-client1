component  {

    remote string function delete(required numeric id) {
        
        // check if pm task has work order already that is closed
        query name="local.qI" {
            echo('SELECT * FROM work_order WHERE PMTaskId=#arguments.id# AND Status="Close"');
        }
         
        if(local.qI.recordcount)    {
            abort "PM Task #arguments.id# can not be deleted because it has one or more Workorder(s) associated with it. However, you can still disable the PM Task";
        }
        else    {
            // delete open work order with pm task id above
            transaction action="begin" {
                query {
                    echo('DELETE FROM work_order WHERE PMTaskId=#arguments.id# AND Status="Open"');
                }
                query {
                    echo('DELETE FROM pm_task WHERE PMTaskId=#arguments.id#');
                }
            }
        }
                
        return "PM task #arguments.id# deleted";
    }
}

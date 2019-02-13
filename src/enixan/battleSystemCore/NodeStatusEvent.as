package enixan.battleSystemCore {

    /**
     * Class store a *status* of current event that can be used after dispatch
     * This functionality using in the **Behaviour Tree** pattern
     * @author EdwardBrave
     * */
    public class NodeStatusEvent extends ObjDataEvent{

    //USING_STATUSES____________________________________________________________________________________________________
        /**using as status value*/
        public static const STATUS_SUCCESS:String = "statusSuccess";
        /**using as status value*/
        public static const STATUS_RUNNING:String = "statusRunning";
        /**using as status value. Allows to check the NULL value of the _status*/
        public static const STATUS_UNDEFINED:String = "statusUndefined";
        /**using as status value*/
        public static const STATUS_FAILURE:String = "statusFailure";
        /**Default node's status value. Allows to check unused nodes of *BehaviourTree*. */
        public static const STATUS_UNUSED:String = "statusUnused";

    //END_USING_STATUSES------------------------------------------------------------------------------------------------

    //USING_RULES_______________________________________________________________________________________________________
        /**
         * Work like **AND**. If *ALL* statuses was **STATUS_SUCCESS** then returns **STATUS_SUCCESS**
         * Note. if at least one status was **STATUS_RUNNING** then it always returns **STATUS_RUNNING**
         * using as rule of statuses values collection*/
        public static const RULE_CONJUNCTION:String = "&&";
        /**
         * Work like **OR**. If at least one status was **STATUS_SUCCESS** then returns **STATUS_SUCCESS**
         * Note. if at least one status was **STATUS_RUNNING** then it always returns **STATUS_RUNNING**
         * using as rule of statuses values collection*/
        public static const RULE_DISJUNCTION:String = "||";
    //END_USING_RULES---------------------------------------------------------------------------------------------------

        /** define rule type of statuses values collection*/
        private var _rule:String;

        /** storing status of current event*/
        private var _status:String;

        /**
         * gives current status of the Event
         * @return (int) status (STATUS_SUCCESS / STATUS_RUNNING / STATUS_FAILURE)
         * */
        public function get status():String {
            if(_status == STATUS_UNDEFINED) {
                trace("#>>enixan.battleSystemCore.NodeStatusEvent::set_status:57");
                trace("#>>EventWarning! Status wasn't changed in any listener by this moment.");
            }
            return _status;
        }

        /**
         * Collect new status according defined rules
         * @param value given status that will be collected
         * */
        public function set status(value:String):void {
            if (_status == STATUS_UNDEFINED) {
                _status = value;
            }else if(value == STATUS_RUNNING) {
                _status = STATUS_RUNNING;
            }else if(_status != STATUS_RUNNING && (_rule == RULE_CONJUNCTION) == (_status == STATUS_SUCCESS)) {
                    _status = value;
            }
        }

        /**
         * Class store a *status* of current event that can be used after dispatch
         * This functionality using in the **Behaviour Tree** pattern
         * @param _type go to parent for details
         * @param bubbles go to parent for details
         * @param cancelable go to parent for details
         * @param data additional information that can be add to event
         * @param rule type of rule of statuses values collection
         * */
        public function NodeStatusEvent(_type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null, rule:String = RULE_DISJUNCTION) {
            super(_type, bubbles, cancelable, data);
            _rule = rule;
            _status = STATUS_UNDEFINED;
        }
    }
}

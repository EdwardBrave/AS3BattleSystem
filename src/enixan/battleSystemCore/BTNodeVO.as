package enixan.battleSystemCore {

    /**.**View Object** of BTNodeVO prototype that using in **BehaviourTree** logic*/
    public class BTNodeVO {

        /**Pointer on data object of current **EntityVO***/
        private var _data:Object;

        /**Current execution status of the node*/
        public var status:String;

        /**Number of the last **BehaviourTree** update when node was executed*/
        public var iteration:uint;


        /**
         * Create the **ViewObject** for node of **BehaviourTree**
         * @param data **Object** that contain **type**, **eventType**, **settings**, **forceRunning** condition and list of nodes.
         * *struct : { type:(String), eventType:(String), settings:(Object), nodes:(Vector.<BTNodeVO>), forceRunning:(Boolean) }*
         * @param hardCopy if true it create copy of given data and storing the values in self (not by a pointer)
         * */
        public function BTNodeVO(data:Object, hardCopy:Boolean = false) {
            if (hardCopy) {
                _data = {};
                for (var item:String in data) {
                    _data[item] = data[item];
                }
            } else {
                _data = data;
            }
            status = NodeStatusEvent.STATUS_UNUSED;
            iteration = 0;
            //TYPES_VALIDATION__________________________________________________________________________________________
            if (!(_data.type is String)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.type to String", 1034);
            }
            if (!(_data.eventType == null || _data.eventType is String)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.eventType to String", 1034);
            }
            if (!(_data.nodes == null || _data.nodes is Vector.<BTNodeVO>)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.nodes to Vector.<BTNodeVO>", 1034);
            }
            //END-------------------------------------------------------------------------------------------------------
            if (_data.hasOwnProperty("forceRunning")) {
                _data.forceRunning = (Boolean)(_data.forceRunning);
            } else {
                _data.forceRunning = (_data.type != 'selector');
            }
        }

        /**Type of using node handler. All handlers declared in BehaviourTree.handlers*/
        public function get type():String {
            return _data.type;
        }

        /**Event name that will be dispatched to **BehaviourTree** container in node runtime*/
        public function get eventType():String {
            return _data.eventType;
        }

        /**The settings that change properties of node runtime*/
        public function get settings():Object {
            return _data.settings;
        }

        /**List of sub-nodes that will be executed by chosen handler*/
        public function get nodes():Vector.<BTNodeVO> {
            return _data.nodes;
        }

        /**
         * Allows to ignore queue of sub-nodes and start from node with status = **STATUS_RUNNING** if it exist
         * By usual all handlers except **selector** can ignore queue (forceRunning = true)
         * */
        public function get forceRunning():Boolean {
            return _data.forceRunning;
        }
    }
}

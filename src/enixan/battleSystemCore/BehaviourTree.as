package enixan.battleSystemCore {

    /**
     * Basic behaviour manager. It make decisions moving on nodes using handlers.
     * The final nodes contain behaviour events, that launch components - listeners of events.
     * _________________________________________________________________________________________________________________
     *
     * Every node after execution return one of basic states that show the result of current action:
     * **STATUS_SUCCESS**   - execution completed and one of listeners return a success result;
     * **STATUS_RUNNING**   - execution completed and at least one of listeners return a running result.
     *                      it means that component still in runtime and it dont know result of action;
     * **STATUS_UNDEFINED** - execution completed and no one event listener returned a value;
     * **STATUS_FAILURE**   - execution completed and all of listeners return a failure result;
     * **STATUS_UNUSED**    - (used only in debug) default value of all nodes that help to detect a no handled nodes in any case.
     * _________________________________________________________________________________________________________________
     *
     *  **Handlers** is a methods of current class that can execute different node types and move on the tree in this way.
     *  All handlers divides on 3 basic archetypes by it functionality:
     * **Composite** - This nodes contain sub-nodes and use logic that can manage branches to continue behaviour logic.
     * Only this nodes can react on BTNodeVO.forceRunning which allows to ignore queue of sub-nodes
     * and start from node with status STATUS_RUNNING if it exist;
     * handlers names: *sequence, selector, condition, randomSelector, random*
     * **Decorator** - It can manage only *ONE* sub-node: change returned status and control it execution.
     * handlers names: *inverter, successor*
     * **Leaf**      - It doesnt have a sub notes but only this node can contain an executing functionality.
     * handlers names: *leaf*
     * */
    public class BehaviourTree implements IBehaviourManager {

        /**
         * List of all defined handlers of node. It is a methods of current class that can execute
         * different node types and move on the tree in this way. (read class info for more...)
         * */
        protected static const handlers:Vector.<String> = new <String>['sequence','selector','condition','randomSelector','random','inverter','successor','leaf'];

        /** Count an iterations for adding it in nodes in runtime. Helps in debug*/
        private var iterationsCounter:uint;

        /**Contain all nodes of **BehaviourTree** that executes every *rootTreeUpdate**/
        public var tree:BTNodeVO;

        /**Object of settings for customisation of work logic*/
        protected var _settings:Object;


        /**Pointer on parent Entity*/
        private var _container:Entity;

        /**
         * Give a pointer on parent **Container** or **null** if it still undefined
         * @return pointer on parent **Container**
         * */
        public function get container():Entity {
            return _container;
        }

        /**
         * Take a pointer on parent **Container** and initialize methods and params associated with it
         * @param parent Pointer on parent **Container**
         * */
        public function set container(parent:Entity):void {
            _container = parent;
        }

        /**
         * Basic behaviour manager. It make decisions moving on nodes using handlers.
         * The final nodes contain behaviour events, that launch components - listeners of events.
         * @param data prototype of current BehaviourTree for it customisation
         * */
        public function BehaviourTree(data:BehaviourVO) {
            iterationsCounter = 0;
            this.tree = data.tree;
            _settings = {};
            refreshSettings(data.settings);
        }

        /**
         * Function that reacts on start battle event
         * *You should override this function for use*
         * */
        public function start():void {

        }

        /**
         * Take the settings and refresh *(change)* logic of **BehaviourTree** with them
         * *You should override this function for use*
         * @param settings Values that allows to customise component logic
         * */
        public function refreshSettings(settings:Object):void {
            if (settings) {
                for (var val:String in settings) {
                    _settings[val] = settings[val];
                }
            }
        }

        /**
         * Function that reacts on every update event of battle
         * *You should override this function for use*
         * */
        public function update():void {
            if (!_settings.hasOwnProperty("behaviourUpdateCount") || _settings.behaviourUpdateCount >= _settings._updateCounter++) {
                rootTreeUpdate();
                _settings._updateCounter = 0;
            }

        }

        /**
         * Remove the **BehaviourTree** and all information about it
         * **CAUTION!** After this action the **BehaviourTree** will be dead and unusable
         * */
        public function destruct():void {
            _container = null;
            tree = null;
            _settings = null;
        }

        /**
         * Search a sub-node with needed status, that was executed in previous iteration
         * @param node current node that contain a list of sub-nodes
         * @param status needed status for search
         * @return position node with needed status in node.nodes vector (-1 if it doesn't exist)
         * */
        private function getStatusPos(node:BTNodeVO, status:String = NodeStatusEvent.STATUS_RUNNING):int {
            if (node.forceRunning) {
                var nodes:Vector.<BTNodeVO> = node.nodes;
                for (var i:int = nodes.length-1; i >= 0; i--) {
                    if (nodes[i].iteration == (iterationsCounter - 1) && nodes[i].status == status) {
                        return i;
                    }
                }
            }
            return -1;
        }

        /**
         * Launch behaviour tree iteration. It starts the behaviour tree logic
         * */
        public function rootTreeUpdate():void {
            if (!_container) {
                trace("#>>enixan.battleSystemCore.BehaviourTree::rootTreeUpdate");
                trace("#>>BTWarning! Entity is still undefined! Behaviour can not be dispatched.");
                return;
            }
            iterationsCounter++;
            var status:String = node(tree);
            if (status == NodeStatusEvent.STATUS_FAILURE || status == NodeStatusEvent.STATUS_UNDEFINED) {
                trace("#>>enixan.battleSystemCore.BehaviourTree::rootTreeUpdate:146");
                trace("#>>BTWarning! Behaviour is undefined (STATUS_FAILURE)!");
            }
        }

        /**
         * Search and choose needed handlers for successfully executing of node
         * @param data given node with undefined handler
         * @return status of execution
         * */
        private function node(data:BTNodeVO):String {
            if (data && handlers.indexOf(data.type) != -1) {
                data.status = this[data.type](data);
                data.iteration = iterationsCounter;
            }
            if (data.status == NodeStatusEvent.STATUS_UNDEFINED) {
                trace("#>>enixan.battleSystemCore.BehaviourTree::node:160");
                trace("#>>BTError! Node does not give an answer on event (STATUS_UNDEFINED)!");
            }
            return data.status;
        }

        /**
         * Chose a sub-nodes one by one in queue while it return STATUS_SUCCESS.
         * It return STATUS_SUCCESS only if every sub-nodes statuses will be equal STATUS_SUCCESS.
         * @param data given node with list of sub-nodes
         * @return status of last node execution
         * */
        private function sequence(data:BTNodeVO):String {
            var status:String = NodeStatusEvent.STATUS_UNDEFINED;
            var nodes:Vector.<BTNodeVO> = data.nodes;
            if(nodes) {
                var pos:int = getStatusPos(data);
                pos = (pos < 0) ? 0 : pos;
                for (; pos < nodes.length; pos++) {
                    status = node(nodes[pos]);
                    if (status != NodeStatusEvent.STATUS_SUCCESS) {
                        break;
                    }
                }
            }
            return status;
        }

        /**
         * Chose a sub-nodes one by one in queue until it return STATUS_SUCCESS or STATUS_RUNNING
         * @param data given node with list of sub-nodes
         * @return status of last node execution
         * */
        private function selector(data:BTNodeVO):String {
            var status:String = NodeStatusEvent.STATUS_UNDEFINED;
            var nodes:Vector.<BTNodeVO> = data.nodes;
            if(nodes) {
                var pos:int = getStatusPos(data);
                pos = (pos == -1) ? 0 : pos;
                for (; pos < nodes.length; pos++) {
                    status = node(nodes[pos]);
                    if (status == NodeStatusEvent.STATUS_SUCCESS || status == NodeStatusEvent.STATUS_RUNNING) {
                        break;
                    }
                }
            }
            return status;
        }

        /**
         * Execute it self and choose one of the sub-nodes side according to it execution result.
         * If it execution is not STATUS_SUCCESS or STATUS_FAILURE sub-nodes will be ignored.
         * In case when it contain only one node if STATUS_SUCCESS it will be executed else it return status of it self.
         * If it contain 2 or more sub-nodes if STATUS_FAILURE then will be executed the first sub-node (position **0**),
         * if STATUS_SUCCESS then will be executed the second sub-node (position **1**).
         * All other sub-nodes after the second will be ignored and never executed.
         * @param data given node with list of sub-nodes and condition
         * @return status of chosen node or it self if self-execution status is not STATUS_SUCCESS or STATUS_FAILURE
         * */
        private function condition(data:BTNodeVO):String {
            var status:String = leaf(data);
            if (data.nodes) {
                var pos:int = getStatusPos(data);
                if(pos != -1) {
                    return node(data.nodes[pos]);
                } else if (data.nodes.length >= 2) {
                    if(status == NodeStatusEvent.STATUS_SUCCESS) {
                        return node(data.nodes[1]);
                    }else if(status == NodeStatusEvent.STATUS_FAILURE) {
                        return node(data.nodes[0]);
                    }
                } else if(data.nodes.length >= 1 && status == NodeStatusEvent.STATUS_SUCCESS) {
                    return node(data.nodes[0]);
                }
            }
            return status;
        }

        /**
         * Chose a random sub-nodes one by one until it return STATUS_SUCCESS or STATUS_RUNNING
         * @param data given node with list of sub-nodes
         * @return status of random list of nodes execution
         * */
        private function randomSelector(data:BTNodeVO):String {
            var picks:Vector.<int> = new Vector.<int>();
            var status:String = NodeStatusEvent.STATUS_UNDEFINED;
            if (data.nodes && data.nodes.length) {
                var random:int = 0;
                while(status != NodeStatusEvent.STATUS_SUCCESS && status != NodeStatusEvent.STATUS_RUNNING && picks.length < data.nodes.length) {
                    do{
                        if(picks.length) {
                            random = Math.round(Math.random() * (data.nodes.length - 1));
                        } else {
                            random = getStatusPos(data);
                            random = (random != -1) ? random :  Math.round(Math.random() * (data.nodes.length - 1));
                        }
                    }while(picks.indexOf(random) != -1);
                    status = node(data.nodes[random]);
                    picks.push(random);
                }
            }
            return status;
        }

        /**
         * Chose a ONE random sub-node and return it status
         * @param data given node with list of sub-nodes
         * @return status of chosen node execution
         * */
        private function random(data:BTNodeVO):String {
            if (data.nodes && data.nodes.length) {
                var pos:int = getStatusPos(data);
                pos = (pos != -1) ? pos : Math.round(Math.random() * (data.nodes.length - 1));
                return node(data.nodes[pos]);
            }
            return NodeStatusEvent.STATUS_UNDEFINED;
        }

        /**
         * Inverse a sub-node status
         * @param data given node, status of which will be inverted
         * @return inverted status of execution without
         * (invert only if status is STATUS_SUCCESS or STATUS_FAILURE.
         * In other cases returns sub-node status without changes)
         * */
        private function inverter(data:BTNodeVO):String {
            var status:String = NodeStatusEvent.STATUS_UNDEFINED;
            if (data.nodes && data.nodes.length >= 1) {
                status = node(data.nodes[0]);
                if (status == NodeStatusEvent.STATUS_SUCCESS) {
                    status = NodeStatusEvent.STATUS_FAILURE;
                } else if (status == NodeStatusEvent.STATUS_FAILURE) {
                    status = NodeStatusEvent.STATUS_SUCCESS;
                }
            }
            return status;
        }

        /**
         * If sub-node return a status it always change it to STATUS_SUCCESS
         * @param data given node, status of which will be ignored
         * @return STATUS_SUCCESS (or STATUS_UNDEFINED is it has no sub-node)
         * */
        private function successor(data:BTNodeVO):String {
            if (data.nodes && data.nodes.length >= 1) {
                var status:String = node(data.nodes[0]);
                if (status == NodeStatusEvent.STATUS_FAILURE)
                    return NodeStatusEvent.STATUS_SUCCESS;
                return status;
            }
            return NodeStatusEvent.STATUS_UNDEFINED;
        }

        /**
         * Dispatch an event of current node to the parent container
         * @param data given node that need to execute
         * @return status of execution
         * */
        private function leaf(data:BTNodeVO):String {
            var statusEvent:NodeStatusEvent = new NodeStatusEvent(data.eventType, false, false, data.settings);
            _container.dispatchEvent(statusEvent);
            return statusEvent.status;
        }
    }
}

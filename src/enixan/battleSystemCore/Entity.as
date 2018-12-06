package enixan.battleSystemCore {

    /**
    * This class manage communication between their components and state machine. It is an environment for their correct work
    * */
    public class Entity extends Container implements IComponent {

        /**Pointer on **BehaviourManager** that control components behaviour in current environment*/
        protected var _behaviourManager:IBehaviourManager;

        /**Pointer on parent container*/
        private var _container:Container;

        /**Object of settings for customisation of work logic*/
        protected var _settings:Object;

        /**
         * Sets the **BehaviourManager** that control components behaviour in current environment
         * @param newManager Pointer on given **BehaviourManager**
         * */
        public function set behaviourManager(newManager:IBehaviourManager):void {
            if (_behaviourManager) {
                _behaviourManager.destruct();
            }
            _behaviourManager = newManager;
            _behaviourManager.container = this;
        }

        /**
         * **Entity** is have no processes that working without global update
         * @return It always will be **null**
         * */
        public function get process():Process {
            return null;
        }

        /**
         * Set parent container if it exists
         * @param parent Pointer on parent container
         * */
        public function set container(parent:Container):void {
            _container = parent;
            var updateIndex:int = UpdateManager.onUpdateList.indexOf(update),
                startIndex :int = UpdateManager.onStartList.indexOf(start);
            if (_container) {
                if (updateIndex != -1){
                    UpdateManager.onUpdateList.removeAt(updateIndex);
                }
                if (startIndex != -1){
                    UpdateManager.onStartList.removeAt(startIndex);
                }
            }else{
                if (updateIndex == -1){
                    UpdateManager.onUpdateList.push(update);
                }
                if (startIndex == -1){
                    UpdateManager.onStartList.push(start);
                }
            }
        }

        /**
         * Give parent container if it exists
         * @return Pointer on parent container
         * */
        public function get container():Container {
            return _container;
        }

        /**
         * Constructor of container that provide environment for correct interaction between **Components** and **BehaviourManager**
         * @param settings Values that allows to **Entity** entity logic
         * */
        public function Entity(settings:Object = null) {
            super();
            container = null;
            _settings = {};
            if (settings) {
                init(settings);
            }
        }

        /**
         * Take the settings and initialize **Entity** with them
         * *NOTE! It is an interface for managing Entity and will be better if it never be used*
         * @param settings Values that allows to customise **Entity** logic
         * */
        public function init(settings:Object):void {
            if (settings) {
                for (var val:String in settings) {
                    _settings[val] = settings[val];
                }
            }
        }

        /**
         * Function that reacts on start battle event
         * */
        public function start():void {
            if (_behaviourManager) {
                _behaviourManager.start();
            }
            for each(var component:IComponent in _components) {
                    component.start();
            }
        }

        /**
         * Take the settings and refresh *Entity** with them
         * *NOTE! It is an interface for managing *Components** and will be better if it never be used*
         * @param settings Values that allows to customise *Entity** logic
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
         * */
        public function update():void {
            if (_behaviourManager) {
                _behaviourManager.update();
            }else{
                for each(var component:IComponent in _components) {
                    component.update();
                }
            }

        }

        /**
         * Remove the **Entity** and all information about it
         * **CAUTION!** After this action the **Entity** will be dead and unusable
         * */
        override public function destruct():void {
            var updateIndex:int = UpdateManager.onUpdateList.indexOf(update),
                startIndex :int = UpdateManager.onStartList.indexOf(start);
            if (updateIndex != -1){
                UpdateManager.onUpdateList.removeAt(updateIndex);
            }
            if (startIndex != -1){
                UpdateManager.onStartList.removeAt(startIndex);
            }
            if (_behaviourManager) {
                _behaviourManager.destruct();
            }
            _container = null;
            _settings = null;
            super.destruct();
        }
    }
}

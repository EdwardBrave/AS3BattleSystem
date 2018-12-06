package enixan.battleSystemCore {

    /**
     *  Contains logic about manage and activity steps of components in environment of its container(Entity)
     * */
    public class BehaviourManager implements IBehaviourManager {

        private var _container:Entity;

        private var _settings:Object;

        public function set container(parent:Entity):void {
            _container = parent;
        }

        public function BehaviourManager(settings:Object) {
            _settings = {};
            if (settings) {
                for (var val:String in settings) {
                    _settings[val] = settings[val];
                }
            }
        }


        public function start():void {

        }


        public function update():void {

        }


        public function destruct():void {
            container = null;
            _settings = null;
        }
    }
}

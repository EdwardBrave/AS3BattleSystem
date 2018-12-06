package enixan.battleSystemCore {
    import flash.events.EventDispatcher;

    /**
     * Contains, manage and store logical components of entity
     * */
    public class Container extends EventDispatcher {

        /** Vector of components that contains in current container*/
        protected var _components:Vector.<IComponent>;

        /**
         * Constructor of container that can manage and store logical components
         * */
        public function Container() {
            _components = new Vector.<IComponent>();
        }

        /**
         * Add component to current container
         * @param component The IComponent object that will be added
         * @param index Position of current component in vector *( -1 - auto push)*
         * @return pointer on self *(always)*
         * */
        public function addComponent(component:IComponent, index:int = -1):Container {
            if (_components.indexOf(component) == -1) {
                index = (index < 0 || index >_components.length) ? _components.length : index;
                component.container = this;
                _components.insertAt(index, component);
            }
            return this;
        }

        /**
         * Set component index and queue of update and events
         * @param component The IComponent object for what index will be changed
         * @param index New position of component in vector (if bigger then max then it will equal current vector size)
         * @return pointer on self *(always)*
         * */
        public function setIndex(component:IComponent, index:int):Container {
            var oldIndex:int = _components.indexOf(component);
            if (oldIndex != -1 && 0 <= index) {
                index = (index >_components.length) ? _components.length : index;
                _components.removeAt(oldIndex);
                _components.insertAt(index, component);
            }
            return this;
        }

        /**
         * Get pointer on component by name of it class
         * @param name String name of searched class
         * @return pointer on component or **null** if it doesnt exist
         * */
        public function getComponentByName(name:String):IComponent {
            for each(var component:IComponent in _components) {
                if (component.toString() == name) {
                    return component;
                }
            }
            return null;
        }

        /**
         * Get pointer on component by it index in vector
         * @param index Position of the component in vector
         * @return pointer on component or **null** if it doesnt exist
         * */
        public function getComponentByIndex(index:int):IComponent {
            if (0 <= index && index < _components.length) {
                return _components[index];
            }
            return null;
        }

        /**
         * Remove component from current container
         * @param component The IComponent object that will be removed
         * @return pointer on self *(always)*
         * */
        public function removeComponent(component:IComponent):Container {
            var index:int = _components.indexOf(component);
            if (index != -1) {
                component.destruct();
                _components.removeAt(index);
            }
            return this;
        }

        /**
         * Remove component by index from current container
         * @param index Position of current removable component in vector
         * @return pointer on self *(always)*
         * */
        public function removeAt(index:uint):Container {
            if (0 <= index && index < _components.length) {
                _components[index].destruct();
                _components.removeAt(index);
            }
            return this;
        }


        /**
         * Remove all components but not it self
         * */
        public function clear():void {
            for (var index:int = _components.length - 1; index >= 0 ; index--){
                _components[index].destruct();
                _components.removeAt(index);
            }
        }

        /**
         * Destructor. Remove all components, addiction variables and it self
         * **CAUTION!** After this action the **Container** will be dead and unusable
         * */
        public function destruct():void {
            clear();
            _components = null;
        }
    }
}

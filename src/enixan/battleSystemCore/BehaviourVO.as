package enixan.battleSystemCore {
    /**.**View Object** of entity prototype that using in component creation*/
    public class BehaviourVO {

        /**Pointer on data object of current **EntityVO***/
        private var _data:Object;

        /**
         * Create the **ViewObject** for **BehaviourManager** data
         * @param data **Object** that contain **className**, **settings** for entity and list of nodes - **tree**.
         * *struct : { className:(String), settings:(Object), tree:(BTNodeVO) }*
         * @param hardCopy if true it create copy of given data and storing the values in self (not by a pointer)
         * */
        public function BehaviourVO(data:Object, hardCopy:Boolean = false) {
            if (hardCopy) {
                _data = {};
                for (var item:String in data) {
                    _data[item] = data[item];
                }
            } else {
                _data = data;
            }
            //TYPES_VALIDATION__________________________________________________________________________________________
            if (!(_data.className is String)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.className to String", 1034);
            }
            if (!(_data.tree == null || _data.tree is BTNodeVO)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.tree to BTNodeVO", 1034);
            }
            //END-------------------------------------------------------------------------------------------------------
        }

        /**The name of component class of the **IBehaviourManager** prototype*/
        public function get className():String {
            return _data.className;
        }

        /**The settings that will be applied when will be created an exemplar of current **IBehaviourManager** prototype*/
        public function get settings():Object {
            return _data.settings;
        }

        /**The **BTNodeVO** that contain a behaviour tree logic*/
        public function get tree():BTNodeVO {
            return _data.tree;
        }
    }
}

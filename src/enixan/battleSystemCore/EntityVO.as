package enixan.battleSystemCore {

    /**
     * .**View Object** of entity prototype that using in component creation
     * @author EdwardBrave
     * */
    public class EntityVO {

        /**Pointer on data object of current **EntityVO***/
        private var _data:Object;

        /**
         * Create the **ViewObject** for entity data
         * @param data **Object** that contain **className**, **settings** for entity and list of **children**.
         * *struct : { className:(String), settings:(Object), children:(Vector.<EntityVO>) }*
         * @param hardCopy if true it create copy of given data and storing the values in self (not by a pointer)
         * */
        public function EntityVO(data:Object, hardCopy:Boolean = false) {
            if (hardCopy){
                _data = {};
                for (var item:String in data) {
                    _data[item] = data[item];
                }
            }else{
                _data = data;
            }
            //TYPES_VALIDATION__________________________________________________________________________________________
            if (!(_data.className is String)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.className to String", 1034);
            }
            if (!(_data.behaviourVO == null || _data.behaviourVO is BehaviourVO)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.behaviourVO to BehaviourVO", 1034);
            }
            if (!(_data.children == null || _data.children is Vector.<EntityVO>)) {
                throw new Error("CoreError #1034: Type Coercion failed: cannot convert value of data.children to Vector.<EntityVO>", 1034);
            }
            //END-------------------------------------------------------------------------------------------------------
        }

        /**The name of component class of the entity prototype*/
        public function get className():String {
            return _data.className;
        }

        /**The view object of **BehaviourManager** class of the entity prototype*/
        public function get behaviourVO():BehaviourVO {
            return _data.behaviourVO;
        }

        /**The settings that will be applied when will be created an exemplar of current entity prototype*/
        public function get settings():Object {
            return _data.settings;
        }

        /**The list of other **EntityVO** prototypes that contains in the current entity*/
        public function get children():Vector.<EntityVO> {
            return _data.children;
        }
    }
}

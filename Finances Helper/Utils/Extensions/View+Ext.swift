import SwiftUI

extension View{
    
    func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
    

    func vCenter() -> some View{
        self
            .frame(maxHeight: .infinity, alignment: .center)
    }
 
    func vTop() -> some View{
        self
            .frame(maxHeight: .infinity, alignment: .top)
    }
  
    func vBottom() -> some View{
        self
            .frame(maxHeight: .infinity, alignment: .bottom)
    }

    func hCenter() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func hLeading() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func hTrailing() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
   
    func allFrame() -> some View{
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func withoutAnimation() -> some View {
        self.animation(nil, value: UUID())
    }
    
    var isSmallScreen: Bool{
        getRect().height < 700
    }
    
    
    @ViewBuilder
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat) -> Void) -> some View{
        self
            .overlay{
                GeometryReader { proxy in
                    let minY = proxy.frame(in: coordinateSpace).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}



struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension GeometryProxy {
        var offset: CGFloat {
        frame(in: .global).minY
    }
    var height: CGFloat {
        
        size.height + (offset > 0 ? offset : 0)
        
    }
    var verticalOffset: CGFloat{
        offset > 0 ? -offset : 0
    }
}

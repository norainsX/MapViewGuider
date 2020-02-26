# 在SwiftUI中使用MKMapView

SwiftUI是个好东西，让我们方便进行UI的布局；可如果做得应用和地图有关，那么就没有那么舒心了，因为SwiftUI里面没有封装地图的控件！如果需要使用地图的话，那么我们必须自己动手，将MKMapView给包装进来！好吧，那么我们现在就来看下，如果进行封装吧！

## 基础用法

### 封装MKMapKit

对于UIKit里面的组件，如果我们需要在SwiftUI中使用，只需要在封装的时候满足UIViewRepresentable协议，也就是实现makeUIView(context:)和updateUIView(**_**: , context:) 函数即可。是不是很简单？基于此，我们可以很简单地将MKMapView给包装起来：

```swift
import MapKit
import SwiftUI

struct MapViewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
}

```

使用的时候，和正常的SwiftUI组件没有任何差别，如：

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        MapViewWrapper()
    }
}
```

运行程序，我们就能看到激动人心的画面了：

<img src="README.assets/%E6%88%AA%E5%B1%8F2020-02-26%E4%B8%8B%E5%8D%883.15.07.png" alt="截屏2020-02-26下午3.15.07" style="zoom: 50%;" />

### 设置Frame

如果仔细查看代码，会发现我们之前将frame设置为0，如：

```swift
let mapView = MKMapView(frame: .zero)
```

虽然在实际使用中，运行起来的时候会自动适配，但给人的感觉总是不够完美，就像有鲠在喉一样，难受。那么我们改如何获取MKMapView的应有大小呢？这个时候就要使用GeometryReader了。

我们新建一个MapView的结构体，然后在此结构体中使用GeometryReader将MapViewWrapper给包装起来，并且初始化的时候将父窗口的大小传递给MapViewWrapper，如：

```swift
struct MapView: View {
    var body: some View {
        return GeometryReader { geometryProxy in
            MapViewWrapper(frame: CGRect(x: geometryProxy.safeAreaInsets.leading,
                                         y: geometryProxy.safeAreaInsets.trailing,
                                         width: geometryProxy.size.width,
                                         height: geometryProxy.size.height))
        }
    }
}

struct MapViewWrapper: UIViewRepresentable {
    var frame: CGRect

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: frame)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
}
```

使用的地方，自然是要将MapViewWrapper给修改为MapView了：

```swift
struct ContentView: View {
    var body: some View {
        MapView()
    }
}
```

这样看来，凡是封装的UIKit组件，都先封装，然后再放到一个struct View中，似乎能省不少麻烦。但是，问题来了，在实际上，如果采用这种封装的方式，那么在使用@ObservableObject这种属性的时候，很有可能在数据变化的时候，无法收到变化的通知。所以这里只是说明怎么能够获取frame而已，但在下面的例子中，我们还是要将这个将MapViewWrapper放到MapView中去的这种方式取消的。

### 监控缩放的比例

如果我们使用双手来缩放地图的话，那么我们如何获知此时缩放的倍数呢？这个时候就需要使用上代理了。所谓的代码，就是实现了MKMapViewDelegate协议的类。我们为了保存数据，这里还新建了一个MapViewState的类。之所以这样考量，是鉴于设计模式的原则，将数据和状态分开。

首先是MapViewState类，比较简单，只有一个属性：

```swift
import MapKit

class MapViewState: ObservableObject {
    var span: MKCoordinateSpan?
}

```

接着是MapViewDelegate类，它需要实现MKMapViewDelegate协议，并且为了检测到缩放的事件，还必须实现mapView(**_** mapView: MKMapView, regionDidChangeAnimated: Bool)函数：

```swift
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    var mapViewState : MapViewState
    
    init(mapViewState : MapViewState){
        self.mapViewState = mapViewState
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        mapViewState.span = mapView.region.span
        print(mapViewState.span)
    }
}

```

其次，就是在MapView中将MapViewDelegate的实例赋给它：

```swift

struct MapView: View {
    var mapViewState: MapViewState
    var mapViewDelegate: MapViewDelegate

    var body: some View {
        return GeometryReader { geometryProxy in
            MapViewWrapper(frame: CGRect(x: geometryProxy.safeAreaInsets.leading,
                                         y: geometryProxy.safeAreaInsets.trailing,
                                         width: geometryProxy.size.width,
                                         height: geometryProxy.size.height),
                           mapViewState: self.mapViewState,
                           mapViewDelegate: self.mapViewDelegate)
        }
    }
}

struct MapViewWrapper: UIViewRepresentable {
    var frame: CGRect
    var mapViewState: MapViewState
    var mapViewDelegate: MapViewDelegate

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: frame)
        mapView.delegate = mapViewDelegate
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
}

```

最后，调用的方式也要稍微改一下：

```swift

struct ContentView: View {
    var mapViewState: MapViewState?
    var mapViewDelegate: MapViewDelegate?

    init() {
        mapViewState = MapViewState()
        mapViewDelegate = MapViewDelegate(mapViewState: mapViewState!)
    }

    var body: some View {
        ZStack {
            MapView(mapViewState: mapViewState!, mapViewDelegate: mapViewDelegate!)
        }
    }
}
```

运行程序，这时候应该就能通过调试窗口输出缩放的span了。

最后的最后，总结一下要点：

- MapView的反馈全部是通过MKMapViewDelegate来回调通知的
- MKMapViewDelegate的实例是通过给mapView.delegate赋值实现的
- 缩放的时候，会调用mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool)函数

### 设置显示的中心点

我们这里考虑一个常见的应用场景，就是很多地图软件都会有一个功能，点击“当前位置”按钮的时候，地图就会嗖地显示我们当前的位置。这个场景，要实现也非常容易。

首先，我们需要在MapViewState增加一个center属性来存储位置变量：

```swift
import MapKit

class MapViewState: ObservableObject {
    var span: MKCoordinateSpan?
    @Published var center: CLLocationCoordinate2D?
}

```

这里之所以将MapViewState声明为ObservableObject，以及为何要将center用@Published包装起来，主要是我们的这些数据在变化的时候需要能够通知到SwiftUI的组件。

我们来看MapView的代码需要有什么变化：

```swift

```

上述代码有如下需要注意的地方：

- 设置显示中心点，是由调用setRegion来实现的
- setRegion的latitudinalMeters和longitudinalMeters是用来控制缩放的比例的
- SetRegion的span也是控制缩放比例的，只是单位和前者不同
- 设置之后，将mapViewState.center设置为nil，主要是为了防止刷新的时候不停地设置中心点

接下来，我们就需要在ContentView添加一个按钮，按下按钮的时候设置中心点位置。代码不复杂，只是稍微添加的地方有点多：

```

```


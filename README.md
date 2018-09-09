# RxSwift-MVVM-PoP
My protocol orientated approach on MVVM using RxSwift

## ViewModelType
### This will be the "final" ViewModelType

``` swift
protocol RxViewModelType {
	// setting up the structs as typealiases 
	typealias Input = RxViewModelInputs
	typealias Output = RxViewModelOutputs
	typealias Dependencies = RxViewModelDependencies

	// forcing the inject the input and dependencies inside init
	init(input: Input, dependencies: Dependencies)

	// interface for communicating with the view
	var input: Input { get }
	var output: Output { get }
	var depencencies: Dependencies { get }
}
```

## Dependency Injection: 

### Injector:
Thats my ressource of  different Default-Implentations of all 
fundamental Services / API-Wrappers, I will use in the project.

``` swift
struct Injector {
	static let MapKitService: MapKitAPI = DefaultMapKitAPI()
}
```

### protocol-extensions for the actual inject
By adopting a hasSomeService Protocol, an Object will 
gain access to the default Implementations described above.


``` swift
protocol hasMapKitService { }

extension hasMapKitService { var MapKitService: 
	MapKitAPI { get { return Injector.MapKitService } } 
}
```

## Protocols
### Protocols for inputs / outputs
My Protocols will later be adopted by structs

``` swift
/// Input Interface
protocol RxViewModelInputType {
	var query: Driver<String> { get }
	var buttonTapped: Signal<()> { get }
	var cellTapped: Driver<(Int,Int)> { get }
} 

/// Output Interface
protocol RxViewModelOutputType {
	var models: Driver<[AutoSuggestionsModel]> { get }
	var unbind: Signal<()> { get }
}
```

### Protocol for dependency
The adopter of that RxViewModelDependencyType protocol, will automaticly have a referance on my Core Services

``` swift
/// Dependency Interface
protocol RxViewModelDependencyType: hasMapKitService {}
```

## Structs
Structs will adopt the protocols
They define the typealias for my "final" ViewModel-Interace
I use mostly use the Driver Trait for my ViewModels, because it's running on the main Thread and therefore good 
for UI related tasks.

``` swift
// Auto adopts my dependencies
struct RxViewModelDependencies: RxViewModelDependencyType { }

// Output - RxSwift
struct RxViewModelOutputs: RxViewModelOutputType {
	let models: Driver<[AutoSuggestionsModel]>
	let unbind: Signal<()>
}

// Input - RxSwift
struct RxViewModelInputs: RxViewModelInputType {
	let query: Driver<String>
	let buttonTapped: Signal<()>
	let cellTapped: Driver<(Int,Int)>
}
```

# How to contribute
Feel invited to share any thought! 
I'd appreciate any kind of constructive criticism! 

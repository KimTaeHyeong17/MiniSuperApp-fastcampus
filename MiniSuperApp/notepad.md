//
//  notepad.swift
//  MiniSuperApp
//
//  Created by TaeHyeong Kim on 2021/10/25.
//

# ModernRibs -> Ribs에서 RxSwift를 걷어내고 Combine을 적용한 라이브러리

# Ribs
- 리블렛: Builder, Interactor, Router, View로 이루어진 하나의 단위
(돼지고기 갈빗대 하나를 리블렛이라고도 함)

# Builder
- 리블렛에 객체를 생성하는 역할 (appHomeBuilder는 appHome 리블렛을 만든다.)
- build 메소드에서 리블렛에 필요한 객체를 생성
- component에 로직을 수행하는데 필요한 객체를 담는 바구니

# Interactor
- 비즈니스 로직이 들어가는 두뇌

# Router
- 리블렛 간의 이동을 담당한다.

리블렛은 하나의 부모 리블렛을 가지고 여러 자식 리블렛을 가진다.
리블렛을 뗏다 붙였다 하는건 라우터의 역할

AppHomeListener는 Apphome 리블렛이 부모 리블렛에게 이벤트를 전달할때 사용한다.
(익숙한 델리게이트 패턴)

- build 메소드는 라우터를 리턴하는데 리턴된 라우터는 부모 리블렛이 사용함
- 부모 리블렛은 이 라우터를 가지고 2가지 작업을 한다.
AppRootBuilder를 보면 3개의 리블렛을 붙이기 위해 3가지 빌더를 만든다.
라우터의 attachTabs에서 빌드 메서드를 호출해 라우터를 받아서
1. attachChild를 호출해준다. (립스 트리를 만들어서 레퍼런스를 유지)
2. 뷰컨트롤러를 띄운다. (router의, viewcontrollable: UIVIewController를 감싼 인터페이스)
- 인터페이스를 통해 UIKit을 직접 사용하지 않을 수 있음

navigationControllerable은 위 viewcontrollable과 동일


하나의 단위는 리블렛으로 Builder, Interactor, Router, View
Builder: 리블렛의 객체를 생성하고 라우터를 리턴
Interactor: 로직이 들어가는 두뇌
Router: 리블렛 트리 만들고 뷰끼리 라우팅 역할(자식 리블렛의 빌터를 만들고 attach하고 띄운다.)




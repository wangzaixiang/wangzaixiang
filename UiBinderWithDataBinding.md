# Introduction #

the UiBinder provide a declarative ui support for GWT, but it still missing data binding support which is useful for UI programming.

# Samples #

Demo SimpleForm.ui.xml
```
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
	xmlns:g="urn:import:com.google.gwt.user.client.ui">
	<ui:style>
		
	</ui:style>
	<g:HTMLPanel>
		
		UserName:		<g:TextBox ui:field="wUserName" value="@userName"/> <br/>
		Password:		<g:PasswordTextBox ui:field="wPassword" value="@password"/>
	
	</g:HTMLPanel>
</ui:UiBinder> 
```
Demo Simple.java
```
public class SimpleForm extends Composite {

	private static Binder uiBinder = GWT.create(Binder.class);

	interface Binder extends UiBinderX<Widget, SimpleForm> {
	}

	@UiField
	TextBox wUserName;

	@UiField
	PasswordTextBox wPassword;

	// either box or the owner support PropertyChangeEvent
	Box<String> userName;
	Box<String> password;

	public SimpleForm() {
		initWidget(uiBinder.createAndBindUi(this));
	}

}
```

The example is follows the current UiBinder usage, but with extensions:
  * "@userName" means the field is now a bound expression which bound to "owner.userName" field
  * bound means: when the widget's value changed, the userName field is synchronized, also, when you set the userName's value, the widget is updated automated. You need no more code for the two-way synchronize.
  * "@userName" also support nested path such as "@user.name" where user is a JavaBean and name is the sub properties.

Also, the UiBinderX interface is extends from UiBinder, and add the follow methods:
  * flush(): flush from data model to ui, which is useful when some bean does not support the VCH(HasValueChangeHandlers).
  * save(): flush from ui to model, which is useful when some widget does not support the VCH.

# Synchronize Process #
the synchronize is follows the GWT's VCH design, once a value changed, it fires listener ValueChangeEvent and notify the listener to update its status.

a new class Box[T](T.md) such as Box[String](String.md), Box[Date](Date.md) is defined to contains simple model value, the Box support VCH and can be used in other JavaBeans to support data synchronize.

the GWT framework always support the VCH and we will directly use it, it support only the "value" property, but it is the general case, so we don't extends it to other property.


# Please give me comments and feedback #
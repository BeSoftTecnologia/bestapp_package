import 'package:flutter/material.dart';

// Usuando <T> para permitir ele soportar eses tipo de tipo
/*
  Exemple
  BeinputDropdownController(
    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
    hintText: "Gender",
    options: ["Male", "Female"],
    // value: '',
    onChanged: (String value) {
      print('value $value');
      setState(() {
        // gender = value;
        // state.didChange(newValue);
      });
    },
    getLabel: (String value) => value,
  ),
*/
class BeinputDropdownController<T> extends StatelessWidget {
  final String hintText;
  final List<T> options;
  final T value;
  final String Function(T) getLabel;
  final void Function(T) onChanged;
  final bool fulwidth;
  final EdgeInsetsGeometry padding;
  final double width;
  final IconData prefixIcon;
  final bool validator;
  final EdgeInsetsGeometry contentPadding;
  final bool isExpanded;
  final bool isDense;
  final int elevation;
  final double borderRadius;

  BeinputDropdownController({
    this.hintText = 'Selecione sua Opção',
    this.options = const [],
    this.getLabel,
    this.contentPadding,
    this.value,
    this.onChanged,
    this.fulwidth = true,
    this.padding,
    this.width,
    this.prefixIcon,
    this.validator=false,
    this.elevation=2,
    this.isDense=false,
    this.isExpanded=false,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fulwidth ? MediaQuery.of(context).size.width : width,
      padding: padding != null ? padding :  EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FormField<T>(
        validator: (value) {
          if(validator){
            return null;
          }else{
            return '';
          }
        },
        builder: (FormFieldState<T> state) {
          return InputDecorator(
              decoration: InputDecoration(
                contentPadding: contentPadding,
                prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                hintText:  hintText ?? hintText,
                errorText: validator ? null : 'Campo não pode estar vazio!'
              ),
              isEmpty:  value == null || value == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: isExpanded,
                  isDense: isDense,
                  value: value,
                  elevation: elevation,
                  borderRadius: BorderRadius.circular(borderRadius),
                  onChanged: onChanged,
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  items: options.map((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 10),
                            Text(
                              getLabel(value),
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  }).toList(),
                ),
              )
          );
        }
      )
    );
  }
}
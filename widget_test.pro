pro widget_test
  tlb = Widget_Base(/Row, /Exclusive)
  button1 = Widget_Button(tlb, Value=ColorButtonBitmap('Button 1')) 
  button2 = Widget_Button(tlb, Value=ColorButtonBitmap('Button 2', $
                                                       FGCOLOR='YELLOW', BGCOLOR='NAVY'))
  button3 = Widget_Button(tlb, Value=ColorButtonBitmap('Button 3', $
                                                       BGCOLOR='YELLOW', FGCOLOR='INDIAN RED'))
  Widget_Control, tlb, /Realize
end

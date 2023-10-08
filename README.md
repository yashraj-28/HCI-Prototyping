## COSC 559: Human Computer Interaction
### Bakeoff 1: Pointing
- Developed in [Processing](https://processing.org)
- [Video explanation]()
- [Presentation Slides](https://nbviewer.org/github/yashraj-28/HCI-Prototyping/blob/main/Slides.pdf)
  
### Initial Ideas:

1. Make highlight color Red. 
2. Flash a square (between Red and White) when highlighted. 
3. Reduce visibility of un-highlighted squares. 
4. Draw a line from center of the highlighted square to the cursor.
5. Remove the mouse and make cursor color Cyan.
6. Shrink cursor when it hovers over the highlighted square.
7. Play sound feedback when a square is highlighted.
8. Play sound feedback on hit/ miss.


### Prototype 1:

    Ideas implemented: 1-5
    Ideas rejected: 6, 7, 8


### First Refinement:
- Modifications for better contrast
    - Make the cursor bright green instead of Cyan. 
    - Remove the black stroke around cursor.
    - Increase stroke weight.
- Keep all the other ideas.


### Prototype 2 (New ideas):
1. Make workspace full screen.
2. Decrease the sensitivity of mouse.

### Final Prototype:
- Revert the sensitivity to default.
- Keep all the other ideas:
    1. Remove mouse pointer, make cursor color Green.
    2. Reduce cursor size when it hovers over highlighted square.
    3. Flash square (with colors red and white) on highlight. 
    4. Dim un-highlighted squares slightly.
    5. Include shortest path line from cursor to center of highlighted square.
    6. Make workspace fullscreen.



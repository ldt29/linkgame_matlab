function b = checkActive
    screenSize = get(0,'screensize');
    p0 = get(gcf, 'Position');
    
    import java.awt.MouseInfo;
    mousePoint = MouseInfo.getPointerInfo().getLocation(); 
    
    b = (mousePoint.x > p0(1) && ...
        mousePoint.x < p0(1) + p0(3) && ...
        mousePoint.y > screenSize(4) - p0(2) - p0(4) && ...
        mousePoint.y < screenSize(4) - p0(2));
end


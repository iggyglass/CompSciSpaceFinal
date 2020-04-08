Mesh mesh = new Mesh(new Triangle[] {
    // SOUTH
    new Triangle(new Vector3(0.0f, 0.0f, 0.0f), new Vector3(0.0f, 1.0f, 0.0f), new Vector3(1.0f, 1.0f, 0.0f)),
    new Triangle(new Vector3(0.0f, 0.0f, 0.0f), new Vector3(1.0f, 1.0f, 0.0f), new Vector3(1.0f, 0.0f, 0.0f)),

    // EAST                                                      
    new Triangle(new Vector3(1.0f, 0.0f, 0.0f), new Vector3(1.0f, 1.0f, 0.0f), new Vector3(1.0f, 1.0f, 1.0f)),
    new Triangle(new Vector3(1.0f, 0.0f, 0.0f), new Vector3(1.0f, 1.0f, 1.0f), new Vector3(1.0f, 0.0f, 1.0f)),

    // NORTH                                                     
    new Triangle(new Vector3(1.0f, 0.0f, 1.0f), new Vector3(1.0f, 1.0f, 1.0f), new Vector3(0.0f, 1.0f, 1.0f)),
    new Triangle(new Vector3(1.0f, 0.0f, 1.0f), new Vector3(0.0f, 1.0f, 1.0f), new Vector3(0.0f, 0.0f, 1.0f)),

    // WEST                                                      
    new Triangle(new Vector3(0.0f, 0.0f, 1.0f), new Vector3(0.0f, 1.0f, 1.0f), new Vector3(0.0f, 1.0f, 0.0f)),
    new Triangle(new Vector3(0.0f, 0.0f, 1.0f), new Vector3(0.0f, 1.0f, 0.0f), new Vector3(0.0f, 0.0f, 0.0f)),

    // TOP                                                       
    new Triangle(new Vector3(0.0f, 1.0f, 0.0f), new Vector3(0.0f, 1.0f, 1.0f), new Vector3(1.0f, 1.0f, 1.0f)),
    new Triangle(new Vector3(0.0f, 1.0f, 0.0f), new Vector3(1.0f, 1.0f, 1.0f), new Vector3(1.0f, 1.0f, 0.0f)),

    // BOTTOM                                                    
    new Triangle(new Vector3(1.0f, 0.0f, 1.0f), new Vector3(0.0f, 0.0f, 1.0f), new Vector3(0.0f, 0.0f, 0.0f)),
    new Triangle(new Vector3(1.0f, 0.0f, 1.0f), new Vector3(0.0f, 0.0f, 0.0f), new Vector3(1.0f, 0.0f, 0.0f))

});
Matrix4x4 matProj = new Matrix4x4();

float zNear = 0.1f;
float zFar = 1000.0f;
float fov = 90.0f;

float theta = 0.0f;

long pFrameTime = 0;

void setup()
{
    size(1000, 1000);
    
    float aspectRatio = (float)height / (float)width;
    float fovRad = 1.0f / tan(fov * 0.5f / 180.0f * 3.14159f);

    matProj.M[0][0] = aspectRatio * fovRad;
    matProj.M[1][1] = fovRad;
    matProj.M[2][2] = zFar / (zFar - zNear);
    matProj.M[3][2] = (-zFar * zNear) / (zFar - zNear);
    matProj.M[2][3] = 1.0f;
    matProj.M[3][3] = 0.0f;
}

void draw()
{
    background(0);
    fill(0, 0, 0, 0);
    stroke(255, 255, 255, 255);

    long currentTime = millis();
    long deltaTime = currentTime - pFrameTime;

    theta += 0.001f * (float)deltaTime;

    // Draw Mesh
    for (int i = 0; i < mesh.Tris.size(); i++)
    {
        Triangle triProj = new Triangle();
        Triangle tri = new Triangle(mesh.Tris.get(i));

        Triangle triTrans = tri;

        triTrans.Points[0].Z += sin(theta) + 3;
        triTrans.Points[1].Z += sin(theta) + 3;
        triTrans.Points[2].Z += sin(theta) + 3;
        triTrans.Points[0].Y += cos(theta);
        triTrans.Points[1].Y += cos(theta);
        triTrans.Points[2].Y += cos(theta);
        triTrans.Points[0].X += cos(theta);
        triTrans.Points[1].X += cos(theta);
        triTrans.Points[2].X += cos(theta);

        triProj.Points[0] = matProj.MultiplyVector(triTrans.Points[0]);
        triProj.Points[1] = matProj.MultiplyVector(triTrans.Points[1]);
        triProj.Points[2] = matProj.MultiplyVector(triTrans.Points[2]);

        // Scale into view
        triProj.Points[0].X += 1.0f;
        triProj.Points[0].Y += 1.0f;
        triProj.Points[1].X += 1.0f;
        triProj.Points[1].Y += 1.0f;
        triProj.Points[2].X += 1.0f;
        triProj.Points[2].Y += 1.0f;

        triProj.Points[0].X *= 0.5f * (float)width;
        triProj.Points[0].Y *= 0.5f * (float)height;
        triProj.Points[1].X *= 0.5f * (float)width;
        triProj.Points[1].Y *= 0.5f * (float)height;
        triProj.Points[2].X *= 0.5f * (float)width;
        triProj.Points[2].Y *= 0.5f * (float)height;

        triangle(triProj.Points[0].X, triProj.Points[0].Y, triProj.Points[1].X, triProj.Points[1].Y, triProj.Points[2].X, triProj.Points[2].Y);
    }

    pFrameTime = currentTime;
}

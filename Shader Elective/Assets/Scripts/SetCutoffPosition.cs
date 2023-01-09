using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
[RequireComponent(typeof(Renderer))]
public class SetCutoffPosition : MonoBehaviour
{
    //Publics
    [Tooltip("In here goes an empty Waterline GameObject which determines the height of the fluid.")]
    [SerializeField]
    private Transform _waterLineGizmo;

    //Privates
    private Material _material;
    private Renderer _renderer;

    private void OnEnable()
    {
        _renderer = GetComponent<Renderer>();
        //_material = renderer.sharedMaterial;
    }

    private void Update()
    {
        if(_waterLineGizmo != null)
        {
            var propertyBlock = new MaterialPropertyBlock();
            propertyBlock.SetVector("_CutoffPosition", _waterLineGizmo.position);
            propertyBlock.SetVector("_CutoffNormal", _waterLineGizmo.up);
            _renderer.SetPropertyBlock(propertyBlock);
        }
    }

}
